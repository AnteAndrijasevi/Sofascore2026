import Foundation

nonisolated struct LeagueStanding: Decodable, Identifiable, Sendable, Hashable {
    let team: Team
    let position: Int
    let matches: Int
    let wins: Int
    let losses: Int
    let draws: Int
    let percentage: Double?
    let points: Int?
    let scoreFor: Int
    let scoreAgainst: Int
    let scoreFormatted: String

    var id: Int { team.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(team.id)
    }

    static func == (lhs: LeagueStanding, rhs: LeagueStanding) -> Bool {
        lhs.team.id == rhs.team.id
            && lhs.position == rhs.position
            && lhs.matches == rhs.matches
            && lhs.wins == rhs.wins
            && lhs.draws == rhs.draws
            && lhs.losses == rhs.losses
            && lhs.points == rhs.points
            && lhs.scoreFormatted == rhs.scoreFormatted
            && lhs.percentage == rhs.percentage
    }
}
