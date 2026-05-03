import UIKit
import SofaAcademic

final class EventDetailsViewModel {

    let homeTeamName: String
    let awayTeamName: String
    let homeTeamLogoUrl: String?
    let awayTeamLogoUrl: String?
    let homeScore: String?
    let awayScore: String?
    let statusLine: String
    let isLive: Bool
    let startDate: String
    let startTime: String
    let leagueName: String
    let countryName: String?
    let leagueLogoUrl: String?
    let result: MatchResult?
    let sportName: String

    var homeTeamLogo: UIImage?
    var awayTeamLogo: UIImage?
    var leagueLogo: UIImage?

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

    var dashTextColor: UIColor {
        result?.dashColor(isLive: isLive) ?? AppColors.secondaryText
    }

    var statusTextColor: UIColor {
        result?.statusColor(isLive: isLive) ?? AppColors.secondaryText
    }

    var titleText: String {
        let parts = [sportName, countryName ?? "", leagueName].filter { !$0.isEmpty }
        return parts.joined(separator: AppStrings.titleSeparator)
    }

    init(event: Event, sport: Sport) {
        homeTeamName = event.homeTeam.name
        awayTeamName = event.awayTeam.name
        homeTeamLogoUrl = event.homeTeam.logoUrl
        awayTeamLogoUrl = event.awayTeam.logoUrl

        sportName = sport.title

        startDate = EventDetailsHelper.formattedDate(from: event.startTimestamp)
        startTime = EventDetailsHelper.formattedTime(from: event.startTimestamp)

        leagueName = event.league?.name ?? ""
        countryName = event.league?.country?.name
        leagueLogoUrl = event.league?.logoUrl

        switch event.status {
        case .finished:
            statusLine = AppStrings.fullTimeDetail
            isLive = false
        case .inProgress:
            statusLine = AppStrings.inProgressPlaceholder
            isLive = true
        case .halftime:
            statusLine = AppStrings.halfTimeDetail
            isLive = true
        case .notStarted:
            statusLine = AppStrings.notStarted
            isLive = false
        }

        if let home = event.homeScore, let away = event.awayScore {
            homeScore = "\(home)"
            awayScore = "\(away)"
            if home > away {
                result = .homeWin
            } else if away > home {
                result = .awayWin
            } else {
                result = .draw
            }
        } else {
            homeScore = nil
            awayScore = nil
            result = nil
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

        if let urlString = leagueLogoUrl, let url = URL(string: urlString) {
            group.enter()
            ImageService.fetchImage(from: url) { [weak self] image in
                self?.leagueLogo = image
                group.leave()
            }
        }

        group.notify(queue: .main) {
            completion()
        }
    }
}
