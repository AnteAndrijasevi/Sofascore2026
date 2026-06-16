import UIKit

@MainActor
final class MatchRowViewModel: MatchColorProviding {
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
    private(set) var homeTeamLogo: UIImage?
    private(set) var awayTeamLogo: UIImage?

    init(event: Event) {
        self.homeTeamName = event.homeTeam.name
        self.awayTeamName = event.awayTeam.name
        self.homeTeamLogoUrl = event.homeTeam.logoUrl
        self.awayTeamLogoUrl = event.awayTeam.logoUrl

        self.timeOrStatus = DateFormattersHelper.formattedTime(from: event.startTimestamp)

        self.statusLine = event.status.shortStatusLine
                self.isLive = event.status.isLive

                if let home = event.homeScore, let away = event.awayScore {
                    self.homeScore = "\(home)"
                    self.awayScore = "\(away)"
                } else {
                    self.homeScore = nil
                    self.awayScore = nil
                }
                self.result = MatchResult(homeScore: event.homeScore, awayScore: event.awayScore)
    }

    func fetchImages(completion: @escaping () -> Void) {
            Task { @MainActor [weak self] in
                guard let self else { return }
                async let home = ImageService.image(fromString: self.homeTeamLogoUrl)
                async let away = ImageService.image(fromString: self.awayTeamLogoUrl)
                (self.homeTeamLogo, self.awayTeamLogo) = await (home, away)
                completion()
            }
        }
}
