import UIKit

@MainActor
final class LeagueDetailsViewModel {

    struct MatchesGroup {
        let header: String
        let events: [Event]
    }

    let leagueId: Int
    let sport: Sport
    let leagueName: String
    let countryName: String
    let leagueLogoUrl: String?

    var onMatchesUpdate: (([MatchesGroup]) -> Void)?
    var onMatchesError: (() -> Void)?
    var onStandingsUpdate: (([LeagueStanding]) -> Void)?
    var onStandingsError: (() -> Void)?

    private var matchesTask: Task<Void, Never>?
    private var standingsTask: Task<Void, Never>?

    private static let dayFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEE dd.MM."
            return formatter
        }()
    
    init(league: League, sport: Sport) {
        self.leagueId = league.id
        self.sport = sport
        self.leagueName = league.name
        self.countryName = league.country?.name ?? ""
        self.leagueLogoUrl = league.logoUrl
    }

    func loadMatches() {
        matchesTask?.cancel()
        matchesTask = Task { [weak self] in
            guard let self else { return }
            do {
                let events = try await APIClient.shared.fetchLeagueMatches(leagueId: leagueId)
                try Task.checkCancellation()
                let groups = makeGroups(from: events, sport: sport)
                onMatchesUpdate?(groups)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                onMatchesError?()
            }
        }
    }

    func loadStandings() {
        standingsTask?.cancel()
        standingsTask = Task { [weak self] in
            guard let self else { return }
            do {
                let standings = try await APIClient.shared.fetchStandings(leagueId: leagueId)
                try Task.checkCancellation()
                onStandingsUpdate?(standings)
            } catch is CancellationError {
                            return
            } catch {
                guard !Task.isCancelled else { return }
                onStandingsError?()
            }
        }
    }

    private func makeGroups(from events: [Event], sport: Sport) -> [MatchesGroup] {
        switch sport {
        case .football, .americanFootball:
            return makeRoundGroups(from: events)
        case .basketball:
            return makeDayGroups(from: events)
        }
    }

    private func makeRoundGroups(from events: [Event]) -> [MatchesGroup] {
        let byRound = Dictionary(grouping: events) { $0.round ?? 0 }
        let sortedRounds = byRound.keys.sorted()
        return sortedRounds.map { round in
            MatchesGroup(
                header: AppStrings.round(round),
                events: byRound[round] ?? []
            )
        }
    }

    private func makeDayGroups(from events: [Event]) -> [MatchesGroup] {
        let calendar = Calendar.current
        let byDay = Dictionary(grouping: events) { event in
            calendar.startOfDay(for: Date(timeIntervalSince1970: TimeInterval(event.startTimestamp)))
        }
        return byDay.keys.sorted().map { day in
            MatchesGroup(
                header: Self.dayFormatter.string(from: day),
                events: byDay[day] ?? []
            )
        }
    }
    
    func fetchHeaderImage(completion: @escaping (UIImage?) -> Void) {
        let urlString = leagueLogoUrl
        Task {
            completion(await ImageService.image(fromString: urlString))
        }
    }
}
