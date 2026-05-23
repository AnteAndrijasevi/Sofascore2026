import Foundation

struct LeagueGroup {
    let section: MatchesSection
    let events: [Event]
}

@MainActor
final class MatchesViewModel {

    private(set) var selectedSport: Sport = .football
    var onUpdate: (([LeagueGroup]) -> Void)?
    var onError: (() -> Void)?

    private var loadTask: Task<Void, Never>?

    func selectSport(_ sport: Sport) {
        selectedSport = sport
        loadEvents()
    }

    func loadEvents() {
        loadTask?.cancel()
        loadTask = Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let events = try await APIClient.shared.fetchEvents(for: selectedSport.slug)
                try Task.checkCancellation()
                try? EventsRepository.shared.store(events: events)
                onUpdate?(Self.makeGroups(from: events))
            } catch {
                guard !Task.isCancelled else { return }
                onError?()
            }
        }
    }

    private static func makeGroups(from events: [Event]) -> [LeagueGroup] {
        let eventsByLeague = Dictionary(grouping: events, by: { $0.league.id })
        var seenLeagueIds = Set<Int>()
        var groups: [LeagueGroup] = []
        for event in events where seenLeagueIds.insert(event.league.id).inserted {
            groups.append(
                LeagueGroup(
                    section: MatchesSection(league: event.league),
                    events: eventsByLeague[event.league.id] ?? []
                )
            )
        }
        return groups
    }
}
