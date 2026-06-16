import Foundation

nonisolated struct Incident: Decodable, Sendable {
    let type: IncidentType
    let minute: Int
    let extraMinute: Int?
    let isHomeTeam: Bool?
    let player: String?
    let scoreDiff: Int?
    let score: String?
    let detail: String?

    private enum CodingKeys: String, CodingKey {
        case type, minute, extraMinute, isHomeTeam, player, scoreDiff, score
        case detail = "description"
    }
}
