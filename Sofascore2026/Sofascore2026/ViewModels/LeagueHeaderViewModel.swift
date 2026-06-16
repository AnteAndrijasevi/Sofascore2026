import UIKit

@MainActor
final class LeagueHeaderViewModel {
    let logoUrl: String?
    let countryName: String
    let leagueName: String
    private(set) var logoImage: UIImage?

    init(countryName: String, leagueName: String, logoUrl: String?) {
        self.logoUrl = logoUrl
        self.countryName = countryName
        self.leagueName = leagueName
    }

    func fetchImage(completion: @escaping () -> Void) {
            guard let urlString = logoUrl, let url = URL(string: urlString) else {
                completion()
                return
            }
            Task { @MainActor [weak self] in
                guard let self else { return }
                self.logoImage = await ImageService.image(from: url)
                completion()
            }
        }
}
