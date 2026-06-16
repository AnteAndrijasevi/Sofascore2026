import Foundation

nonisolated struct Tournament: Decodable, Identifiable, Hashable, Sendable {
    let id: Int
    let name: String
    let logoUrl: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Tournament, rhs: Tournament) -> Bool {
        lhs.id == rhs.id
    }
}
