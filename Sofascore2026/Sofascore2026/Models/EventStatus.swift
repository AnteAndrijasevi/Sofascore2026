nonisolated enum EventStatus: String, Decodable, Sendable {
    case notStarted = "NOT_STARTED"
    case inProgress = "IN_PROGRESS"
    case halftime   = "HALF_TIME"
    case finished   = "FINISHED"
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = EventStatus(rawValue: raw) ?? .unknown
    }
}

extension EventStatus {
    var isLive: Bool {
        switch self {
        case .inProgress, .halftime: return true
        case .finished, .notStarted, .unknown: return false
        }
    }

    var shortStatusLine: String {
        switch self {
        case .finished:            return AppStrings.fullTime
        case .inProgress:          return AppStrings.inProgressPlaceholder
        case .halftime:            return AppStrings.halfTime
        case .notStarted, .unknown: return AppStrings.notStarted
        }
    }


    var detailStatusLine: String {
        switch self {
        case .finished:            return AppStrings.fullTimeDetail
        case .inProgress:          return AppStrings.inProgressPlaceholder
        case .halftime:            return AppStrings.halfTimeDetail
        case .notStarted, .unknown: return AppStrings.notStarted
        }
    }
}
