import Foundation

nonisolated struct Player: Decodable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let shortName: String?
    let position: String?
    let jerseyNumber: String?
    let country: Country?
    let imageUrl: String?
    let isForeign: Bool?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Player, rhs: Player) -> Bool {
        lhs.id == rhs.id
    }
}
