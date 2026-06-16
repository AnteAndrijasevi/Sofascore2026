import Foundation
import GRDB

nonisolated struct EventRecord: Codable, FetchableRecord, PersistableRecord, Sendable {
    static let databaseTableName = "event"

    let id: Int
    let leagueId: Int
    let homeTeamName: String
    let awayTeamName: String
    let startTimestamp: Int
    let status: String
    let homeScore: Int?
    let awayScore: Int?

    init(event: Event) {
        self.id = event.id
        self.leagueId = event.league.id
        self.homeTeamName = event.homeTeam.name
        self.awayTeamName = event.awayTeam.name
        self.startTimestamp = event.startTimestamp
        self.status = event.status.rawValue
        self.homeScore = event.homeScore
        self.awayScore = event.awayScore
    }
}
