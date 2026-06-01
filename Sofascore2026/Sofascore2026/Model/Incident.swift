import Foundation

struct Incident: Decodable, Sendable {
    let type: IncidentType
    let minute: Int
    let extraMinute: Int?
    let isHomeTeam: Bool?
    let player: String?
    let scoreDiff: Int?
    let score: String?
    let description: String?
}

extension Incident: Identifiable {
    var id: String {
        "\(minute)-\(extraMinute ?? 0)-\(type.rawValue)-\(player ?? "")-\(isHomeTeam ?? false)-\(score ?? "")"
    }
}
