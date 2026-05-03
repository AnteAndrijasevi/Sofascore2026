import SofaAcademic

extension Event: @retroactive @unchecked Sendable {}

nonisolated extension Event: @retroactive Hashable, @retroactive Equatable {
    public static func == (lhs: Event, rhs: Event) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
