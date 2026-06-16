import UIKit
import SnapKit

final class LeagueMatchesView: UIView {

    private typealias DataSource = UITableViewDiffableDataSource<String, Event>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<String, Event>

    private let tableView = UITableView()
    private var diffableDataSource: DataSource?
    private let errorView = EmptyStateView()

    var onEventSelected: ((Event) -> Void)?

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
        tableView.rowHeight = MatchRowCell.rowHeight
        tableView.sectionHeaderHeight = 44
        tableView.sectionHeaderTopPadding = 0
        tableView.register(MatchRowCell.self, forCellReuseIdentifier: MatchRowCell.identifier)
        tableView.register(
            RoundSectionHeaderView.self,
            forHeaderFooterViewReuseIdentifier: RoundSectionHeaderView.identifier
        )
        tableView.delegate = self
    }

    private func configureDataSource() {
            diffableDataSource = DataSource(tableView: tableView) { tableView, indexPath, event in
                MatchRowCell.dequeueConfigured(in: tableView, at: indexPath, for: event)
            }
        }

    func update(with groups: [LeagueDetailsViewModel.MatchesGroup]) {
            errorView.hide()
            var snapshot = Snapshot()
            for group in groups {
                snapshot.appendSections([group.header])
                snapshot.appendItems(group.events, toSection: group.header)
            }
            diffableDataSource?.apply(snapshot, animatingDifferences: true)
        }

    func showError() {
        errorView.show()
        let snapshot = Snapshot()
        diffableDataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension LeagueMatchesView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: RoundSectionHeaderView.identifier
        ) as? RoundSectionHeaderView else { return nil }

        guard let sectionIdentifiers = diffableDataSource?.snapshot().sectionIdentifiers,
              section < sectionIdentifiers.count else { return nil }

        header.configure(title: sectionIdentifiers[section])
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let event = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        onEventSelected?(event)
    }
}
