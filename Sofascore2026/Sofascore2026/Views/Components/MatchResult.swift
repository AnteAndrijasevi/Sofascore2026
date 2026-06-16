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

// MARK: - Init from score
extension MatchResult {
    init?(homeScore: Int?, awayScore: Int?) {
        guard let homeScore, let awayScore else { return nil }
        if homeScore > awayScore {
            self = .homeWin
        } else if awayScore > homeScore {
            self = .awayWin
        } else {
            self = .draw
        }
    }
}

// MARK: - MatchColorProviding
@MainActor
protocol MatchColorProviding {
    var result: MatchResult? { get }
    var isLive: Bool { get }
}

extension MatchColorProviding {
    var homeTeamTextColor: UIColor {
        result?.homeTeamColor(isLive: isLive) ?? AppColors.primaryText
    }

    var awayTeamTextColor: UIColor {
        result?.awayTeamColor(isLive: isLive) ?? AppColors.primaryText
    }

    var homeScoreTextColor: UIColor {
        result?.homeScoreColor(isLive: isLive) ?? AppColors.primaryText
    }

    var awayScoreTextColor: UIColor {
        result?.awayScoreColor(isLive: isLive) ?? AppColors.primaryText
    }

    var statusTextColor: UIColor {
        result?.statusColor(isLive: isLive) ?? AppColors.secondaryText
    }
}
