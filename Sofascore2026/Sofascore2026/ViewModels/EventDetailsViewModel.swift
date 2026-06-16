import UIKit

@MainActor
final class EventDetailsViewModel: MatchColorProviding {

    let homeTeam: Team
    let awayTeam: Team
    let league: League
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
    let eventId: Int
    let sport: Sport
    let round: Int?

    private(set) var homeTeamLogo: UIImage?
    private(set) var awayTeamLogo: UIImage?
    private(set) var leagueLogo: UIImage?
    var sportName: String { sport.title }

    var dashTextColor: UIColor {
            result?.dashColor(isLive: isLive) ?? AppColors.secondaryText
        }

    var isUpcoming: Bool {
        homeScore == nil
    }

    func makeLeagueDetailsViewModel() -> LeagueDetailsViewModel {
        LeagueDetailsViewModel(league: league, sport: sport)
    }

    var titleText: String {
        var parts = [sportName, countryName ?? "", leagueName].filter { !$0.isEmpty }
        if let round {
            parts.append(AppStrings.round(round))
        }
        return parts.joined(separator: AppStrings.titleSeparator)
    }

    init(event: Event, sport: Sport) {
        self.homeTeam = event.homeTeam
        self.awayTeam = event.awayTeam
        self.league = event.league
        self.eventId = event.id
        self.sport = sport
        switch sport {
        case .football, .americanFootball:
            self.round = event.round
        case .basketball:
            self.round = nil
        }
        homeTeamName = event.homeTeam.name
        awayTeamName = event.awayTeam.name
        homeTeamLogoUrl = event.homeTeam.logoUrl
        awayTeamLogoUrl = event.awayTeam.logoUrl

        startDate = DateFormattersHelper.formattedDate(from: event.startTimestamp)
        startTime = DateFormattersHelper.formattedTime(from: event.startTimestamp)

        leagueName = event.league.name
        countryName = event.league.country?.name
        leagueLogoUrl = event.league.logoUrl

        statusLine = event.status.detailStatusLine
        isLive = event.status.isLive

        if let home = event.homeScore, let away = event.awayScore {
            homeScore = "\(home)"
            awayScore = "\(away)"
        } else {
            homeScore = nil
            awayScore = nil
        }
        result = MatchResult(homeScore: event.homeScore, awayScore: event.awayScore)
    }

    func fetchImages(completion: @escaping (UIImage?, UIImage?, UIImage?) -> Void) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            async let home = ImageService.image(fromString: self.homeTeamLogoUrl)
            async let away = ImageService.image(fromString: self.awayTeamLogoUrl)
            async let league = ImageService.image(fromString: self.leagueLogoUrl)
            let (homeLogo, awayLogo, leagueLogo) = await (home, away, league)
            self.homeTeamLogo = homeLogo
            self.awayTeamLogo = awayLogo
            self.leagueLogo = leagueLogo
            completion(homeLogo, awayLogo, leagueLogo)
        }
    }
}
