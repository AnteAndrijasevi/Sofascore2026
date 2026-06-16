import Foundation
import OSLog

@MainActor
final class MatchesViewModel {
    
    struct LeagueGroup {
        let section: MatchesSection
        let events: [Event]
    }

    private nonisolated static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Sofascore2026",
        category: "MatchesViewModel"
    )

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
        loadTask = Task { [weak self] in
            guard let self else { return }
            do {
                let events = try await APIClient.shared.fetchEvents(for: selectedSport.slug)
                try Task.checkCancellation()
                onUpdate?(Self.makeGroups(from: events))

                await Self.persist(events: events)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                onError?()
            }
        }
    }

    private static func persist(events: [Event]) async {
        await Task.detached(priority: .utility) {
            do {
                try EventsRepository.shared.store(events: events)
            } catch {
                logger.error("Spremanje eventova nije uspjelo: \(String(describing: error))")
            }
        }.value
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
