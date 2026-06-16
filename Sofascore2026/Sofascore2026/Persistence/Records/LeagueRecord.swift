import Foundation
import GRDB

nonisolated struct LeagueRecord: Codable, FetchableRecord, PersistableRecord, Sendable {
    static let databaseTableName = "league"

    let id: Int
    let name: String
    let countryName: String?
    let logoUrl: String?

    init(league: League) {
        self.id = league.id
        self.name = league.name
        self.countryName = league.country?.name
        self.logoUrl = league.logoUrl
    }
}
