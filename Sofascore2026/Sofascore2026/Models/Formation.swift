import Foundation

enum Formation: String, CaseIterable, Identifiable {
    case f433 = "4-3-3"
    case f442 = "4-4-2"
    case f352 = "3-5-2"
    case f343 = "3-4-3"

    var id: String { rawValue }
    var title: String { rawValue }

    var defenders: Int {
        switch self {
        case .f433, .f442: return 4
        case .f352, .f343: return 3
        }
    }

    var midfielders: Int {
        switch self {
        case .f433:        return 3
        case .f442, .f343: return 4
        case .f352:        return 5
        }
    }

    var attackers: Int {
        switch self {
        case .f433, .f343: return 3
        case .f442, .f352: return 2
        }
    }

    func count(for line: PitchLine) -> Int {
        switch line {
        case .goalkeeper: return 1
        case .defense:    return defenders
        case .midfield:   return midfielders
        case .attack:     return attackers
        }
    }
}

enum PitchLine: CaseIterable {
    case goalkeeper, defense, midfield, attack

    static let layoutOrder: [PitchLine] = [.attack, .midfield, .defense, .goalkeeper]

    var title: String {
        switch self {
        case .goalkeeper: return AppStrings.lineGoalkeepers
        case .defense:    return AppStrings.lineDefenders
        case .midfield:   return AppStrings.lineMidfielders
        case .attack:     return AppStrings.lineAttackers
        }
    }
}
