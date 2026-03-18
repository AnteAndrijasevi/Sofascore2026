import UIKit

extension MatchesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: LeagueHeaderView.identifier
        ) as? LeagueHeaderView else { return nil }

        guard let section = diffableDataSource?.snapshot().sectionIdentifiers[section] else { return nil }

        let viewModel = LeagueHeaderViewModel(
            countryName: section.countryName,
            leagueName: section.leagueName,
            logoUrl: section.logoUrl
        )
        viewModel.fetchImage {
            header.configure(with: viewModel)
        }

        return header
    }
}
