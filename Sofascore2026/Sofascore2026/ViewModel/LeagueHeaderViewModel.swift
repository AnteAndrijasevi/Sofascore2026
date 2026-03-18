import UIKit

final class LeagueHeaderViewModel {
    let logoUrl: String?
    let countryName: String
    let leagueName: String
    var logoImage: UIImage?

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
        ImageService.fetchImage(from: url) { [weak self] image in
            self?.logoImage = image
            completion()
        }
    }
}
