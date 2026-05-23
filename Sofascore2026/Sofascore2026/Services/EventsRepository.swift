import Foundation
import GRDB

final class EventsRepository {
    static let shared = EventsRepository()

    private let dbQueue = DatabaseManager.shared.dbQueue

    private init() {}

    func store(events: [Event]) throws {
        try dbQueue.write { db in
            for event in events {
                try LeagueRecord(league: event.league).save(db)
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
