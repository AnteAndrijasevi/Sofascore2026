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
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            if let data = data {
                self?.logoImage = UIImage(data: data)
            }
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
}
