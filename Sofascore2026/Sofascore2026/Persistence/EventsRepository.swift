import Foundation
import GRDB

nonisolated final class EventsRepository: Sendable {
    static let shared = EventsRepository()

    enum RepositoryError: Error {
        case databaseUnavailable
    }

    private init() {}

    private var dbQueue: DatabaseQueue {
        get throws {
            guard let queue = DatabaseManager.shared.dbQueue else {
                throw RepositoryError.databaseUnavailable
            }
            return queue
        }
    }

    func store(events: [Event]) throws {
        try dbQueue.write { db in
            var savedLeagueIds = Set<Int>()
            for event in events {
                if savedLeagueIds.insert(event.league.id).inserted {
                    try LeagueRecord(league: event.league).save(db)
                }
                try EventRecord(event: event).save(db)
            }
        }
    }

    func eventCount() throws -> Int {
        try dbQueue.read { db in
            try EventRecord.fetchCount(db)
        }
    }

    func leagueCount() throws -> Int {
        try dbQueue.read { db in
            try LeagueRecord.fetchCount(db)
        }
    }

    func deleteAll() throws {
        try dbQueue.write { db in
            try EventRecord.deleteAll(db)
            try LeagueRecord.deleteAll(db)
        }
    }
}
