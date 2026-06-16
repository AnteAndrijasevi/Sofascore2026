import Foundation

nonisolated struct Team: Decodable, Sendable {
    let id: Int
    let name: String
    let logoUrl: String?
    let country: Country?
}
