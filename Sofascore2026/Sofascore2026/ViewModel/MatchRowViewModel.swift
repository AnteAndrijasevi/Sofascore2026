//
//  MatchRowViewModel.swift
//  Sofascore2026
//
//  Created by Ante Andrijašević on 10/03/2026.
//

import SofaAcademic
import Foundation

struct MatchRowViewModel {
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
    let awayWon: Bool?

    init(event: Event) {
        self.homeTeamName = event.homeTeam.name
        self.awayTeamName = event.awayTeam.name
        self.homeTeamLogoUrl = event.homeTeam.logoUrl
        self.awayTeamLogoUrl = event.awayTeam.logoUrl

        switch event.status {
        case .finished:
            self.timeOrStatus = Self.formattedTime(from: event.startTimestamp)
            self.statusLine = "FT"
            self.isLive = false
        case .inProgress:
            self.timeOrStatus = Self.formattedTime(from: event.startTimestamp)
            self.statusLine = "36'" 
            self.isLive = true
        case .halftime:
            self.timeOrStatus = Self.formattedTime(from: event.startTimestamp)
            self.statusLine = "HT"
            self.isLive = true
        case .notStarted:
            self.timeOrStatus = Self.formattedTime(from: event.startTimestamp)
            self.statusLine = "-"
            self.isLive = false
        }

        if let home = event.homeScore, let away = event.awayScore {
            self.homeScore = "\(home)"
            self.awayScore = "\(away)"
            self.homeWon = home > away
            self.awayWon = away > home
        } else {
            self.homeScore = nil
            self.awayScore = nil
            self.homeWon = nil
            self.awayWon = nil
        }
    }

    private static func formattedTime(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
}
