//
//  LeagueHeaderViewModel.swift
//  Sofascore2026
//
//  Created by Ante Andrijašević on 10/03/2026.
//

import SofaAcademic

struct LeagueHeaderViewModel {
    let logoUrl: String?
    let countryName: String
    let leagueName: String

    init(league: League) {
        self.logoUrl = league.logoUrl
        self.countryName = league.country?.name ?? ""
        self.leagueName = league.name
    }
}
