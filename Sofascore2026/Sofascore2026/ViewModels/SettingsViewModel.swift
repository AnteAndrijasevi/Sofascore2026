import Foundation
import OSLog

@MainActor
final class SettingsViewModel {
    let userName: String?
    private(set) var countText: String = ""
    
    private nonisolated static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Sofascore2026",
        category: "SettingsViewModel"
    )

    var onCountsUpdate: (() -> Void)?

    init() {
        userName = TokenStore.shared.userName
    }

    func loadCounts() {
        Task { [weak self] in
            let (events, leagues) = await Self.fetchCounts()
            guard let self else { return }
            countText = "\(AppStrings.eventsCount): \(events)\n\(AppStrings.leaguesCount): \(leagues)"
            onCountsUpdate?()
        }
    }

    private static func fetchCounts() async -> (events: Int, leagues: Int) {
        await Task.detached(priority: .utility) {
            let events = (try? EventsRepository.shared.eventCount()) ?? 0
            let leagues = (try? EventsRepository.shared.leagueCount()) ?? 0
            return (events, leagues)
        }.value
    }

    func logout() {
        TokenStore.shared.clear()
        Task.detached(priority: .utility) {
            do {
                try EventsRepository.shared.deleteAll()
            } catch {
                Self.logger.error("Brisanje baze pri odjavi nije uspjelo: \(String(describing: error))")
            }
        }
    }
}
