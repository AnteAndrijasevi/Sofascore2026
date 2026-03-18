import SofaAcademic

extension Event: @unchecked Sendable {}

nonisolated extension Event: Hashable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
