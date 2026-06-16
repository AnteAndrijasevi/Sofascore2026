import UIKit

@MainActor
final class PlayerCellViewModel {
    let name: String
    let countryName: String?
    private let imageUrl: String?
    private(set) var avatar: UIImage?

    init(player: Player) {
        name = player.name
        countryName = player.country?.name
        imageUrl = player.imageUrl
    }

    func fetchImage(completion: @escaping () -> Void) {
        Task { @MainActor [weak self] in
            guard let self else { return }
            self.avatar = await ImageService.image(fromString: imageUrl)
            completion()
        }
    }
}
