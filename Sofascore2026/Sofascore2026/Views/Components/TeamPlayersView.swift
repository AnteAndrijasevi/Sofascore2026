import UIKit
import SnapKit

final class TeamPlayersView: UIView {

    private typealias DataSource = UITableViewDiffableDataSource<Int, Player>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Player>

    private let tableView = UITableView()
    private var diffableDataSource: DataSource?
    private let errorView = EmptyStateView()

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
        addSubview(tableView)
        addSubview(errorView)
    }

    private func styleViews() {
        backgroundColor = AppColors.surface
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColors.surface
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func setupTableView() {
        tableView.rowHeight = 56
        tableView.sectionHeaderTopPadding = 0
        tableView.register(PlayerCell.self, forCellReuseIdentifier: PlayerCell.identifier)
    }

    private func configureDataSource() {
        diffableDataSource = DataSource(tableView: tableView) { tableView, indexPath, player in
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: PlayerCell.identifier,
                        for: indexPath
                    ) as? PlayerCell else { return UITableViewCell() }

                    let viewModel = PlayerCellViewModel(player: player)
                    cell.configure(with: viewModel)
                    viewModel.fetchImage { [weak cell] in
                        guard let cell else { return }
                        cell.updateAvatarIfStillRelevant(for: viewModel)
                    }
                    return cell
                }
    }

    func update(with players: [Player]) {
        errorView.hide()
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(players, toSection: 0)
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }

    func showError() {
        errorView.show()                     
        let snapshot = Snapshot()
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}
