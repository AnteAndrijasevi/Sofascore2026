import UIKit

enum StandingsColumn {
    static let positionSize: CGFloat = 24
    
    case played, wins, draws, losses, goals, points, diff, percentage

    static func columns(for sport: Sport) -> [StandingsColumn] {
        switch sport {
        case .football:         return [.played, .wins, .draws, .losses, .goals, .points]
        case .basketball:       return [.played, .wins, .losses, .diff, .percentage]
        case .americanFootball: return [.played, .wins, .draws, .losses, .percentage]
        }
    }

    var title: String {
        switch self {
        case .played:     return AppStrings.columnPlayed
        case .wins:       return AppStrings.columnWins
        case .draws:      return AppStrings.columnDraws
        case .losses:     return AppStrings.columnLosses
        case .goals:      return AppStrings.columnGoals
        case .points:     return AppStrings.columnPoints
        case .diff:       return AppStrings.columnDiff
        case .percentage: return AppStrings.columnPercentage
        }
    }

    var width: CGFloat {
        switch self {
        case .goals: return 40
        default:     return 24
        }
    }

    func value(for standing: LeagueStanding) -> String {
        switch self {
        case .played:     return "\(standing.matches)"
        case .wins:       return "\(standing.wins)"
        case .draws:      return "\(standing.draws)"
        case .losses:     return "\(standing.losses)"
        case .goals:      return "\(standing.scoreFor):\(standing.scoreAgainst)"
        case .points:     return standing.points.map(String.init) ?? "-"
        case .diff:       return standing.scoreFormatted
        case .percentage:
            guard let percentage = standing.percentage else { return "-" }
            return String(format: "%.3f", percentage)
        }
    }
}
