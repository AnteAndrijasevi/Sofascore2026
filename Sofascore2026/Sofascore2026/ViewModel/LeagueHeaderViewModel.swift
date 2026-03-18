import UIKit
import SofaAcademic

final class LeagueHeaderViewModel {
    let logoUrl: String?
    let countryName: String
    let leagueName: String
    var logoImage: UIImage?

    init(league: League) {
        self.logoUrl = league.logoUrl
        self.countryName = league.country?.name ?? ""
        self.leagueName = league.name
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
