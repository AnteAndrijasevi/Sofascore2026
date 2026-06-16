nonisolated enum IncidentType: String, Decodable, Sendable {
    case goal       = "GOAL"
    case foul       = "FOUL"
    case yellowCard = "YELLOW_CARD"
    case redCard    = "RED_CARD"
    case periodEnd  = "PERIOD_END"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = IncidentType(rawValue: raw) ?? .unknown
    }
}
