import Foundation

struct SettingsViewModel {
    let userName: String?
    let countText: String

    init() {
        userName = TokenStore.shared.userName
        let events = (try? EventsRepository.shared.eventCount()) ?? 0
        let leagues = (try? EventsRepository.shared.leagueCount()) ?? 0
        countText = "\(AppStrings.eventsCount): \(events)\n\(AppStrings.leaguesCount): \(leagues)"
    }

    func logout() {
        TokenStore.shared.clear()
        try? EventsRepository.shared.deleteAll()
    }
}
