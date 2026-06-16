import Foundation

nonisolated struct Venue: Decodable, Sendable {
    let name: String
    let capacity: Int?
    let city: City?
}

nonisolated struct City: Decodable, Sendable {
    let name: String
}
