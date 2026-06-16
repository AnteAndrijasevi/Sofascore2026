import Foundation
import GRDB
import OSLog

nonisolated final class DatabaseManager: Sendable {
    static let shared = DatabaseManager()

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Sofascore2026",
        category: "DatabaseManager"
    )

    let dbQueue: DatabaseQueue?

    private init() {
        dbQueue = Self.makeQueue()
    }

    private static func makeQueue() -> DatabaseQueue? {
        do {
            let folder = try FileManager.default.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            let dbURL = folder.appendingPathComponent("sofascore.sqlite")
            let queue = try DatabaseQueue(path: dbURL.path)
            try migrator.migrate(queue)
            return queue
        } catch {
            logger.error("On-disk DB setup failed, trying in-memory: \(String(describing: error))")
        }

        do {
            let queue = try DatabaseQueue()
            try migrator.migrate(queue)
            return queue
        } catch {
            logger.error("In-memory DB fallback failed, cache disabled: \(String(describing: error))")
            return nil
        }
    }

    private static var migrator: DatabaseMigrator {
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
