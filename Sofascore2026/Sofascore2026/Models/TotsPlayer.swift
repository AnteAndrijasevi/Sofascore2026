import Foundation

struct TotsPlayer: Identifiable, Equatable {
    let id: Int
    let name: String
    let line: PitchLine
    let number: Int
    let club: Club
}

enum Club {
    case liverpool, manCity, arsenal, chelsea, manUtd, newcastle
    case sunderland, bournemouth, nottinghamForest, fulham, crystalPalace

    var shirtHex: String {
        switch self {
        case .liverpool:        return "#C8102E"
        case .manCity:          return "#6CABDD"
        case .arsenal:          return "#EF0107"
        case .chelsea:          return "#034694"
        case .manUtd:           return "#DA291C"
        case .newcastle:        return "#241F20"   
        case .sunderland:       return "#EB172B"
        case .bournemouth:      return "#B50E12"
        case .nottinghamForest: return "#DD0000"
        case .fulham:           return "#FFFFFF"
        case .crystalPalace:    return "#1B458F"
        }
    }
}
