import Foundation
import GRDB

struct LeagueRecord: Codable, FetchableRecord, PersistableRecord {
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
