import Foundation
import SofaAcademic

nonisolated struct MatchesSection: Hashable, @unchecked Sendable {
    let leagueId: Int
    let leagueName: String
    let countryName: String
    let logoUrl: String?

    init(league: League) {
        self.leagueId = league.id
        self.leagueName = league.name
        self.countryName = league.country?.name ?? ""
        self.logoUrl = league.logoUrl
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(leagueId)
    }

    static func == (lhs: MatchesSection, rhs: MatchesSection) -> Bool {
        lhs.leagueId == rhs.leagueId
    }
}
