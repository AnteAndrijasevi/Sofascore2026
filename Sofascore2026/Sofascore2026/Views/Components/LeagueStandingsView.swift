import UIKit
import SnapKit

final class LeagueStandingsView: UIView {

    private typealias DataSource = UITableViewDiffableDataSource<Int, LeagueStanding>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, LeagueStanding>

    private let tableView = UITableView()
    private let columnsHeaderView = LeagueStandingsHeaderView()
    private var diffableDataSource: DataSource?
    private var sport: Sport = .football
    private let errorView = EmptyStateView()
    var onTeamSelected: ((Team) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        configureDataSource()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
        setupTableView()
    }

    private func addViews() {
        addSubview(columnsHeaderView)
        addSubview(tableView)
        addSubview(errorView)
    }

    private func styleViews() {
        backgroundColor = AppColors.surface
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColors.surface
    }

    private func setupConstraints() {
        columnsHeaderView.snp.makeConstraints {
                    $0.top.leading.trailing.equalToSuperview()
                    $0.height.equalTo(36)
                }
        tableView.snp.makeConstraints {
            $0.top.equalTo(columnsHeaderView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    private func setupTableView() {
            tableView.rowHeight = 44
        tableView.sectionHeaderTopPadding = 0
                tableView.delegate = self
                tableView.register(LeagueStandingsCell.self, forCellReuseIdentifier: LeagueStandingsCell.identifier)
    }

    private func configureDataSource() {
        diffableDataSource = DataSource(tableView: tableView) { [weak self] tableView, indexPath, standing in
                    guard let self,
                          let cell = tableView.dequeueReusableCell(
                            withIdentifier: LeagueStandingsCell.identifier,
                            for: indexPath
                          ) as? LeagueStandingsCell else { return UITableViewCell() }
                    cell.configure(with: standing, sport: self.sport)
                    return cell
                }
    }

    func update(with standings: [LeagueStanding], sport: Sport) {
        errorView.hide()
        self.sport = sport
        columnsHeaderView.configure(for: sport)

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(standings, toSection: 0)
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }

    func showError() {
        errorView.show()
        let snapshot = Snapshot()
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}


// MARK: - UITableViewDelegate
extension LeagueStandingsView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let standing = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        onTeamSelected?(standing.team)
    }
}
