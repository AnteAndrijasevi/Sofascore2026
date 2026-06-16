import Foundation

nonisolated struct TeamDetails: Decodable, Sendable {
    let team: Team
    let manager: Manager?
    let venue: Venue?
}
