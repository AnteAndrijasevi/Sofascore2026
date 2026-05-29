import Foundation
import GRDB

final class DatabaseManager {
    static let shared = DatabaseManager()

    let dbQueue: DatabaseQueue

    private init() {
        do {
            let folder = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let dbURL = folder.appendingPathComponent("sofascore.sqlite")
            dbQueue = try DatabaseQueue(path: dbURL.path)
            try migrator.migrate(dbQueue)
        } catch {
            fatalError("Database setup failed: \(error)")
        }
    }

    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()

        migrator.registerMigration("createTables") { db in
            try db.create(table: "league") { t in
                t.primaryKey("id", .integer)
                t.column("name", .text).notNull()
                t.column("countryName", .text)
                t.column("logoUrl", .text)
            }

            try db.create(table: "event") { t in
                t.primaryKey("id", .integer)
                t.column("leagueId", .integer).notNull()
                t.column("homeTeamName", .text).notNull()
                t.column("awayTeamName", .text).notNull()
                t.column("startTimestamp", .integer).notNull()
                t.column("status", .text).notNull()
                t.column("homeScore", .integer)
                t.column("awayScore", .integer)
            }
        }

        return migrator
    }
}
