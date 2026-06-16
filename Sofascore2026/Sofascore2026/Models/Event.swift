import Foundation

nonisolated struct Event: Decodable, Hashable, Sendable {
    let id: Int
    let homeTeam: Team
    let awayTeam: Team
    let startTimestamp: Int
    let status: EventStatus
    let league: League
    let homeScore: Int?
    let awayScore: Int?
    let round: Int?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Event, rhs: Event) -> Bool {
            lhs.id == rhs.id
                && lhs.homeScore == rhs.homeScore
                && lhs.awayScore == rhs.awayScore
                && lhs.status == rhs.status
        }
}
