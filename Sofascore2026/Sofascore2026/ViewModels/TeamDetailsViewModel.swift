import UIKit

@MainActor
final class TeamDetailsViewModel {
    
    let teamId: Int
    let teamName: String
    let teamLogoUrl: String?
    let countryName: String
    
    private(set) var managerName: String?
    private(set) var managerCountryName: String?
    private(set) var managerImageUrl: String?
    private(set) var venueName: String?
    private(set) var playersCount: Int = 0
    private(set) var tournaments: [Tournament] = []
    private(set) var players: [Player] = []
    private(set) var managerImage: UIImage?
    private(set) var tournamentLogos: [Int: UIImage] = [:]
    
    var onDetailsUpdate: (() -> Void)?
    var onDetailsError: (() -> Void)?
    var onPlayersUpdate: (([Player]) -> Void)?
    var onPlayersError: (() -> Void)?
    
    private var detailsTask: Task<Void, Never>?
    private var playersTask: Task<Void, Never>?
    
    init(team: Team) {
        self.teamId = team.id
        self.teamName = team.name
        self.teamLogoUrl = team.logoUrl
        self.countryName = team.country?.name ?? ""
    }
    
    func loadDetails() {
        detailsTask?.cancel()
        detailsTask = Task { [weak self] in
            guard let self else { return }
            do {
                async let detailsRequest = APIClient.shared.fetchTeamDetails(teamId: teamId)
                async let playersRequest = APIClient.shared.fetchTeamPlayers(teamId: teamId)
                async let tournamentsRequest = APIClient.shared.fetchTeamTournaments(teamId: teamId)
                
                let (details, fetchedPlayers, fetchedTournaments) = try await (detailsRequest, playersRequest, tournamentsRequest)
                try Task.checkCancellation()
                
                managerName = details.manager?.name
                managerCountryName = details.manager?.country?.name
                managerImageUrl = details.manager?.imageUrl
                venueName = details.venue?.name
                playersCount = fetchedPlayers.count
                tournaments = fetchedTournaments
                players = fetchedPlayers
                
                onDetailsUpdate?()
                
                await fetchDetailsImages()
                try Task.checkCancellation()
                onDetailsUpdate?()
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                onDetailsError?()
            }
        }
    }
    
    func loadPlayers() {
        if !players.isEmpty {
            onPlayersUpdate?(players)
            return
        }
        
        playersTask?.cancel()
        playersTask = Task { [weak self] in
            guard let self else { return }
            do {
                let fetchedPlayers = try await APIClient.shared.fetchTeamPlayers(teamId: teamId)
                try Task.checkCancellation()
                players = fetchedPlayers
                playersCount = fetchedPlayers.count
                onPlayersUpdate?(fetchedPlayers)
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                onPlayersError?()
            }
        }
    }
    
    func fetchHeaderImage(completion: @escaping (UIImage?) -> Void) {
            let urlString = teamLogoUrl
            Task {
                completion(await ImageService.image(fromString: urlString))
            }
        }

    private func fetchDetailsImages() async {
            async let manager = ImageService.image(fromString: managerImageUrl)

            let logos = await withTaskGroup(of: (Int, UIImage?).self) { group in
                for tournament in tournaments {
                    guard let urlString = tournament.logoUrl, let url = URL(string: urlString) else { continue }
                    group.addTask { (tournament.id, await ImageService.image(from: url)) }
                }
                var result: [Int: UIImage] = [:]
                for await (id, image) in group {
                    result[id] = image
                }
                return result
            }

            managerImage = await manager
            tournamentLogos = logos
        }
}
