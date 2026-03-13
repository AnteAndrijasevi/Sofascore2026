import UIKit
import SofaAcademic
import Foundation

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
    let homeWon: Bool?
    let isDraw: Bool?
    var homeTeamLogo: UIImage?
    var awayTeamLogo: UIImage?

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()

    init(event: Event) {
        self.homeTeamName = event.homeTeam.name
        self.awayTeamName = event.awayTeam.name
        self.homeTeamLogoUrl = event.homeTeam.logoUrl
        self.awayTeamLogoUrl = event.awayTeam.logoUrl

        switch event.status {
        case .finished:
            self.timeOrStatus = Self.formattedTime(from: event.startTimestamp)
            self.statusLine = AppStrings.fullTime
            self.isLive = false
        case .inProgress:
            self.timeOrStatus = Self.formattedTime(from: event.startTimestamp)
            self.statusLine = "36'"
            self.isLive = true
        case .halftime:
            self.timeOrStatus = Self.formattedTime(from: event.startTimestamp)
            self.statusLine = AppStrings.halfTime
            self.isLive = true
        case .notStarted:
            self.timeOrStatus = Self.formattedTime(from: event.startTimestamp)
            self.statusLine = AppStrings.notStarted
            self.isLive = false
        }

        if let home = event.homeScore, let away = event.awayScore {
            self.homeScore = "\(home)"
            self.awayScore = "\(away)"
            self.homeWon = home > away
            self.isDraw = home == away
        } else {
            self.homeScore = nil
            self.awayScore = nil
            self.homeWon = nil
            self.isDraw = nil
        }
    }

    func fetchImages(completion: @escaping () -> Void) {
        let group = DispatchGroup()

        if let urlString = homeTeamLogoUrl, let url = URL(string: urlString) {
            group.enter()
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data { self?.homeTeamLogo = UIImage(data: data) }
                group.leave()
            }.resume()
        }

        if let urlString = awayTeamLogoUrl, let url = URL(string: urlString) {
            group.enter()
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data { self?.awayTeamLogo = UIImage(data: data) }
                group.leave()
            }.resume()
        }

        group.notify(queue: .main) {
            completion()
        }
    }

    private static func formattedTime(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return dateFormatter.string(from: date)
    }
}
