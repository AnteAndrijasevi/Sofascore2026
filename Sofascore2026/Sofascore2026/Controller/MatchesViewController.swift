import UIKit
import SnapKit
import SofaAcademic

final class MatchesViewController: UIViewController {

    private enum Constants {
        static let headerHeight: CGFloat = 56
        static let rowHeight: CGFloat = 56
        static let sportSelectorHeight: CGFloat = 56
    }

    typealias DataSource = UITableViewDiffableDataSource<MatchesSection, Event>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<MatchesSection, Event>

    private let dataSource = Homework3DataSource()
    private let sportSelectorView = SportSelectorView()
    private let tableView = UITableView()
    private var selectedSport: Sport = .football
    var diffableDataSource: DataSource?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        applySnapshot()
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
        setupActions()
    }

    private func addViews() {
        view.addSubview(sportSelectorView)
        view.addSubview(tableView)
    }

    private func styleViews() {
        view.backgroundColor = AppColors.surface
        tableView.separatorStyle = .none
        tableView.backgroundColor = AppColors.surface
        tableView.rowHeight = Constants.rowHeight
        tableView.sectionHeaderHeight = Constants.headerHeight
        tableView.register(MatchRowCell.self, forCellReuseIdentifier: MatchRowCell.identifier)
        tableView.register(LeagueHeaderView.self, forHeaderFooterViewReuseIdentifier: LeagueHeaderView.identifier)
        tableView.delegate = self
    }

    private func setupConstraints() {
        sportSelectorView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Constants.sportSelectorHeight)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(sportSelectorView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func setupActions() {
        sportSelectorView.onSportSelected = { [weak self] sport in
            self?.selectedSport = sport
            self?.applySnapshot()
        }
    }

    private func configureDataSource() {
        diffableDataSource = DataSource(tableView: tableView) { (tableView: UITableView, indexPath: IndexPath, event: Event) in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: MatchRowCell.identifier,
                for: indexPath
            ) as? MatchRowCell else { return UITableViewCell() }

            let viewModel = MatchRowViewModel(event: event)
            viewModel.fetchImages {
                cell.configure(with: viewModel)
            }
            return cell
        }
    }

    private func applySnapshot() {
        let allEvents = dataSource.events()
        let filteredEvents: [Event]

        switch selectedSport {
        case .football:
            filteredEvents = allEvents
        case .basketball, .americanFootball:
            filteredEvents = []
        }

        var seenLeagueIds = Set<Int>()
        var orderedLeagues: [League] = []

        for event in filteredEvents {
            guard let league = event.league, !seenLeagueIds.contains(league.id) else { continue }
            seenLeagueIds.insert(league.id)
            orderedLeagues.append(league)
        }

        var snapshot = Snapshot()

        for league in orderedLeagues {
            let section = MatchesSection(league: league)
            let leagueEvents = filteredEvents.filter { $0.league?.id == league.id }
            snapshot.appendSections([section])
            snapshot.appendItems(leagueEvents, toSection: section)
        }

        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
}
