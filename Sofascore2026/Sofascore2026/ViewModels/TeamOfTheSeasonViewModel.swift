import SwiftUI
import Combine

// MOCK feature — bez mreže i bez detached taskova. Sve stanje je lokalno.
@MainActor
final class TeamOfTheSeasonViewModel: ObservableObject {

    @Published private(set) var formation: Formation = .f433
    @Published private(set) var picks: [PitchLine: [TotsPlayer?]]
    @Published private(set) var removalNotice: String?
    @Published var isShowingResult = false

    let pool: [TotsPlayer] = TotsPlayerPool.all

    init() {
        picks = Self.emptyPicks(for: .f433)
    }

    // MARK: - Derived

    var selectedPlayers: [TotsPlayer] {
        PitchLine.layoutOrder.flatMap { picks[$0] ?? [] }.compactMap { $0 }
    }

    var selectedCount: Int { selectedPlayers.count }
    var isComplete: Bool { selectedCount == 11 }

    func slotItems(for line: PitchLine) -> [PitchSlot] {
        (picks[line] ?? []).enumerated().map { PitchSlot(id: $0.offset, player: $0.element) }
    }

    func candidates(for line: PitchLine) -> [TotsPlayer] {
        pool.filter { $0.line == line }
    }

    func player(line: PitchLine, slot: Int) -> TotsPlayer? {
        guard let slots = picks[line], slots.indices.contains(slot) else { return nil }
        return slots[slot]
    }

    func isUsed(_ player: TotsPlayer) -> Bool {
        selectedPlayers.contains(player)
    }

    // MARK: - Mutations

    func selectFormation(_ newFormation: Formation) {
        guard newFormation != formation else { return }

        var removed = 0
        var newPicks: [PitchLine: [TotsPlayer?]] = [:]

        for line in PitchLine.layoutOrder {
            let newCount = newFormation.count(for: line)
            let existing = (picks[line] ?? []).compactMap { $0 }
            let kept = Array(existing.prefix(newCount))
            removed += existing.count - kept.count

            var slots = [TotsPlayer?](repeating: nil, count: newCount)
            for (index, player) in kept.enumerated() {
                slots[index] = player
            }
            newPicks[line] = slots
        }

        formation = newFormation
        picks = newPicks
        removalNotice = removed > 0 ? AppStrings.totsRemoved(removed) : nil
    }

    func pick(_ player: TotsPlayer, line: PitchLine, slot: Int) {
        guard var slots = picks[line], slots.indices.contains(slot) else { return }
        if let existing = slots.firstIndex(of: player), existing != slot {
            slots[existing] = nil   
        }
        slots[slot] = player
        picks[line] = slots
    }

    func removePick(line: PitchLine, slot: Int) {
        guard var slots = picks[line], slots.indices.contains(slot) else { return }
        slots[slot] = nil
        picks[line] = slots
    }

    func clearAll() {
        picks = Self.emptyPicks(for: formation)
        removalNotice = nil
    }

    func submit() {
        guard isComplete else { return }
        isShowingResult = true
    }

    func dismissResult() {
        isShowingResult = false
    }
    
    var shareText: String {
        let names = selectedPlayers.map(\.name).joined(separator: ", ")
        return "\(AppStrings.totsShareIntro) (\(formation.title)): \(names)"
    }

    // MARK: - Helpers

    private static func emptyPicks(for formation: Formation) -> [PitchLine: [TotsPlayer?]] {
        var result: [PitchLine: [TotsPlayer?]] = [:]
        for line in PitchLine.layoutOrder {
            result[line] = [TotsPlayer?](repeating: nil, count: formation.count(for: line))
        }
        return result
    }
}

// MARK: - PitchSlot
struct PitchSlot: Identifiable {
    let id: Int
    let player: TotsPlayer?
}
