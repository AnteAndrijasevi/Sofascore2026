import Foundation

nonisolated struct Manager: Decodable, Sendable {
    let id: Int
    let name: String
    let country: Country?
    let imageUrl: String?
}
