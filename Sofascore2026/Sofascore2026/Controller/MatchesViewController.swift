import UIKit
import SnapKit
import SofaAcademic

final class MatchesViewController: UIViewController {

    // MARK: - Constants
    private enum Constants {
        static let headerHeight: CGFloat = 56
        static let rowHeight: CGFloat = 56
        static let sportSelectorHeight: CGFloat = 56
    }

    // MARK: - Properties
    private let dataSource = Homework3DataSource()
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    private let sportSelectorView = SportSelectorView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }

    // MARK: - Setup
    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
        setupActions()
    }

    private func addViews() {
        view.addSubview(sportSelectorView)
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
    }

    private func styleViews() {
        view.backgroundColor = AppColors.surface
        contentStack.axis = .vertical
        contentStack.spacing = 0
    }

    private func setupConstraints() {
        sportSelectorView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(Constants.sportSelectorHeight)
        }

        scrollView.snp.makeConstraints {
            $0.top.equalTo(sportSelectorView.snp.bottom)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }

        contentStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
    }

    private func setupActions() {
        sportSelectorView.onSportSelected = { [weak self] sport in
            // za sada samo print, u zadatku 3.2 ćemo filtrirati
            print("Selected sport: \(sport)")
        }
    }

    // MARK: - Data
    private func populateData() {
        let events = dataSource.events()

        var seenLeagueIds = Set<Int>()
        var orderedLeagues: [League] = []

        for event in events {
            guard let league = event.league, !seenLeagueIds.contains(league.id) else { continue }
            seenLeagueIds.insert(league.id)
            orderedLeagues.append(league)
        }

        for league in orderedLeagues {
            let leagueEvents = events.filter { $0.league?.id == league.id }

            let headerViewModel = LeagueHeaderViewModel(league: league)
            let headerView = LeagueHeaderView()
            headerView.snp.makeConstraints { $0.height.equalTo(Constants.headerHeight) }
            contentStack.addArrangedSubview(headerView)

            headerViewModel.fetchImage {
                headerView.configure(with: headerViewModel)
            }

            for event in leagueEvents {
                let rowViewModel = MatchRowViewModel(event: event)
                let rowView = MatchRowView()
                rowView.snp.makeConstraints { $0.height.equalTo(Constants.rowHeight) }
                contentStack.addArrangedSubview(rowView)

                rowViewModel.fetchImages {
                    rowView.configure(with: rowViewModel)
                }
            }
        }
    
    }
}
