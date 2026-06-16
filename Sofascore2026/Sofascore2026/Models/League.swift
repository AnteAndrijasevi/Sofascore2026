import Foundation

nonisolated struct League: Decodable, Sendable {
    let id: Int
    let name: String
    let country: Country?
    let logoUrl: String?
    let seasonId: Int?
}
