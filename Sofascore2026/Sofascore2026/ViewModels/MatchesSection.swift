import Foundation

nonisolated struct MatchesSection: Hashable, Sendable {
    let league: League

    var leagueId: Int { league.id }
    var leagueName: String { league.name }
    var countryName: String { league.country?.name ?? "" }
    var logoUrl: String? { league.logoUrl }

    init(league: League) {
        self.league = league
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(league.id)
    }

    static func == (lhs: MatchesSection, rhs: MatchesSection) -> Bool {
        lhs.league.id == rhs.league.id
    }
}
