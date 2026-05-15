import UIKit
import SnapKit

final class MatchesViewController: UIViewController {

    private enum Constants {
        static let headerHeight: CGFloat = 56
        static let rowHeight: CGFloat = 56
    }

    typealias DataSource = UITableViewDiffableDataSource<MatchesSection, Event>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MatchesSection, Event>

    private lazy var headerView = HeaderView(onSettingsTapped: handleSettingsTapped)
    private lazy var sportSelectorView = SportSelectorView(onSportSelected: handleSportSelected)
    private let tableView = UITableView()
    private var selectedSport: Sport = .football
    private var diffableDataSource: DataSource?
    private var loadTask: Task<Void, Never>?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        loadEvents()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
        setupDelegates()
    }

    private func addViews() {
        view.addSubview(headerView)
        view.addSubview(sportSelectorView)
        view.addSubview(tableView)
    }

    private func styleViews() {
        view.backgroundColor = AppColors.primary
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColors.surface
        tableView.rowHeight = Constants.rowHeight
        tableView.sectionHeaderHeight = Constants.rowHeight
        tableView.register(MatchRowCell.self, forCellReuseIdentifier: MatchRowCell.identifier)
        tableView.register(LeagueHeaderView.self, forHeaderFooterViewReuseIdentifier: LeagueHeaderView.identifier)
    }

    private func setupDelegates() {
        tableView.delegate = self
    }

    private func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.headerHeight)
        }

        sportSelectorView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(Constants.headerHeight)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(sportSelectorView.snp.bottom)
            $0.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
    }

    private func handleSettingsTapped() {
        let settingsVC = SettingsViewController()
        let navController = UINavigationController(rootViewController: settingsVC)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }

    private func showErrorAlert() {
        let alert = UIAlertController(
            title: AppStrings.errorTitle,
            message: AppStrings.errorMessage,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: AppStrings.ok, style: .default))
        present(alert, animated: true)
    }

    private func handleSportSelected(_ sport: Sport) {
        selectedSport = sport
        loadEvents()
    }


    private func loadEvents() {
        loadTask?.cancel()
        loadTask = Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                let events = try await APIClient.shared.fetchEvents(for: selectedSport.slug)
                try Task.checkCancellation()
                applySnapshot(with: events)
            } catch is CancellationError {
                return
            } catch {
                applySnapshot(with: [])
            }
        }
    }

    private func configureDataSource() {
        diffableDataSource = DataSource(tableView: tableView) { (tableView: UITableView, indexPath: IndexPath, event: Event) in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MatchRowCell.identifier,
                for: indexPath
            ) as? MatchRowCell else { return UITableViewCell() }

            let viewModel = MatchRowViewModel(event: event)
            cell.configure(with: viewModel)
            viewModel.fetchImages { [weak cell] in
                guard let cell else { return }
                cell.updateImagesIfStillRelevant(for: viewModel)
            }
            return cell
        }
    }

    private func applySnapshot(with events: [Event]) {
        let eventsByLeague = Dictionary(grouping: events, by: { $0.league.id })

        var seenLeagueIds = Set<Int>()
        var orderedLeagues: [League] = []
        for event in events where seenLeagueIds.insert(event.league.id).inserted {
            orderedLeagues.append(event.league)
        }

        var snapshot = Snapshot()
        for league in orderedLeagues {
            let section = MatchesSection(league: league)
            snapshot.appendSections([section])
            snapshot.appendItems(eventsByLeague[league.id] ?? [], toSection: section)
        }

        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate
extension MatchesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: LeagueHeaderView.identifier
        ) as? LeagueHeaderView else { return nil }

        guard let sectionIdentifier = diffableDataSource?.snapshot().sectionIdentifiers[section] else { return nil }

        let viewModel = LeagueHeaderViewModel(
            countryName: sectionIdentifier.countryName,
            leagueName: sectionIdentifier.leagueName,
            logoUrl: sectionIdentifier.logoUrl
        )
        header.configure(with: viewModel)
        viewModel.fetchImage { [weak header] in
            guard let header else { return }
            header.updateLogoIfStillRelevant(for: viewModel)
        }

        header.showSeparator(section != 0)

        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let event = diffableDataSource?.itemIdentifier(for: indexPath) else { return }
        let viewModel = EventDetailsViewModel(event: event, sport: selectedSport)
        let eventDetailsVC = EventDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(eventDetailsVC, animated: true)
    }
}
