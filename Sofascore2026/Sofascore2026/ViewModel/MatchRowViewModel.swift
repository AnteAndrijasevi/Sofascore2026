import UIKit
import SofaAcademic

enum MatchResult {
    case homeWin
    case awayWin
    case draw

    var homeTeamColor: UIColor {
        switch self {
        case .awayWin: return AppColors.secondaryText
        case .homeWin, .draw: return AppColors.primaryText
        }
    }

    var awayTeamColor: UIColor {
        switch self {
        case .homeWin: return AppColors.secondaryText
        case .awayWin, .draw: return AppColors.primaryText
        }
    }
}

final class MatchRowViewModel {
    let homeTeamName: String
    let awayTeamName: String
    let homeTeamLogoUrl: String?
    let awayTeamLogoUrl: String?
    let homeScore: String?
    let awayScore: String?
    let timeOrStatus: String
    let statusLine: String
    let isLive: Bool
    let result: MatchResult?
    var homeTeamLogo: UIImage?
    var awayTeamLogo: UIImage?

    var statusLabelColor: UIColor {
        isLive ? AppColors.liveRed : AppColors.secondaryText
    }

    init(event: Event) {
        self.homeTeamName = event.homeTeam.name
        self.awayTeamName = event.awayTeam.name
        self.homeTeamLogoUrl = event.homeTeam.logoUrl
        self.awayTeamLogoUrl = event.awayTeam.logoUrl

        switch event.status {
        case .finished:
            self.timeOrStatus = MatchesHelper.formattedTime(from: event.startTimestamp)
            self.statusLine = AppStrings.fullTime
            self.isLive = false
        case .inProgress:
            self.timeOrStatus = MatchesHelper.formattedTime(from: event.startTimestamp)
            self.statusLine = AppStrings.inProgressPlaceholder
            self.isLive = true
        case .halftime:
            self.timeOrStatus = MatchesHelper.formattedTime(from: event.startTimestamp)
            self.statusLine = AppStrings.halfTime
            self.isLive = true
        case .notStarted:
            self.timeOrStatus = MatchesHelper.formattedTime(from: event.startTimestamp)
            self.statusLine = AppStrings.notStarted
            self.isLive = false
        }

        if let home = event.homeScore, let away = event.awayScore {
            self.homeScore = "\(home)"
            self.awayScore = "\(away)"
            if home > away {
                self.result = .homeWin
            } else if away > home {
                self.result = .awayWin
            } else {
                self.result = .draw
            }
        } else {
            self.homeScore = nil
            self.awayScore = nil
            self.result = nil
        }
    }

    func fetchImages(completion: @escaping () -> Void) {
        let group = DispatchGroup()

        if let urlString = homeTeamLogoUrl, let url = URL(string: urlString) {
            group.enter()
            ImageService.fetchImage(from: url) { [weak self] image in
                self?.homeTeamLogo = image
                group.leave()
            }
        }

        if let urlString = awayTeamLogoUrl, let url = URL(string: urlString) {
            group.enter()
            ImageService.fetchImage(from: url) { [weak self] image in
                self?.awayTeamLogo = image
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion()
        }
    }
}
