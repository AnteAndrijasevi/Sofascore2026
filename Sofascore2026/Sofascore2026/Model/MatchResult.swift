import UIKit

enum MatchResult {
    case homeWin
    case awayWin
    case draw

    func homeTeamColor(isLive: Bool) -> UIColor {
        if isLive { return AppColors.primaryText }
        switch self {
        case .awayWin: return AppColors.secondaryText
        case .homeWin, .draw: return AppColors.primaryText
        }
    }

    func awayTeamColor(isLive: Bool) -> UIColor {
        if isLive { return AppColors.primaryText }
        switch self {
        case .homeWin: return AppColors.secondaryText
        case .awayWin, .draw: return AppColors.primaryText
        }
    }

    func homeScoreColor(isLive: Bool) -> UIColor {
        if isLive { return AppColors.liveRed }
        switch self {
        case .awayWin: return AppColors.secondaryText
        case .homeWin, .draw: return AppColors.primaryText
        }
    }

    func awayScoreColor(isLive: Bool) -> UIColor {
        if isLive { return AppColors.liveRed }
        switch self {
        case .homeWin: return AppColors.secondaryText
        case .awayWin, .draw: return AppColors.primaryText
        }
    }

    func dashColor(isLive: Bool) -> UIColor {
        isLive ? AppColors.liveRed : AppColors.secondaryText
    }

    func statusColor(isLive: Bool) -> UIColor {
        isLive ? AppColors.liveRed : AppColors.secondaryText
    }
}
