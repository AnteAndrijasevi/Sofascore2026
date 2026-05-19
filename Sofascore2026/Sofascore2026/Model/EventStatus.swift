enum EventStatus: String, Decodable, Sendable {
    case notStarted = "NOT_STARTED"
    case inProgress = "IN_PROGRESS"
    case halftime   = "HALF_TIME"
    case finished   = "FINISHED"
}
