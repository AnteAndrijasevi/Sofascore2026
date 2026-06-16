import UIKit
import SnapKit

final class LeagueDetailsViewController: UIViewController {

    private let viewModel: LeagueDetailsViewModel

    private lazy var headerView = DetailsHeaderView(
            title: viewModel.leagueName,
            subtitle: viewModel.countryName,
            tabTitles: [AppStrings.matchesTab, AppStrings.standingsTab],
            subtitleBold: true,
            onBack: { [weak self] in self?.backTapped() },
            onTabSelected: { [weak self] tab in self?.handleTabSelected(tab) }
        )
        private let matchesView = LeagueMatchesView()
        private let standingsView = LeagueStandingsView()
    
    init(viewModel: LeagueDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureHeader()
        setupViewModel()
        viewModel.loadMatches()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
            addViews()
            styleViews()
            setupConstraints()
        }

    private func addViews() {
            view.addSubview(headerView)
            view.addSubview(matchesView)
            view.addSubview(standingsView)
        }

    private func styleViews() {
            view.backgroundColor = AppColors.surface
            standingsView.isHidden = true
        }
    
    private func setupConstraints() {
            headerView.snp.makeConstraints {
                $0.top.leading.trailing.equalToSuperview()
            }

            matchesView.snp.makeConstraints {
                $0.top.equalTo(headerView.snp.bottom)
                $0.leading.trailing.bottom.equalToSuperview()
            }

            standingsView.snp.makeConstraints {
                $0.edges.equalTo(matchesView)
            }
        }


    private func backTapped() {
            navigationController?.popViewController(animated: true)
        }

    private func configureHeader() {
            viewModel.fetchHeaderImage { [weak self] image in
                self?.headerView.setLogo(image)
            }
        }

    private func setupViewModel() {
        viewModel.onMatchesUpdate = { [weak self] groups in
            self?.matchesView.update(with: groups)
        }
        viewModel.onMatchesError = { [weak self] in
            self?.matchesView.showError()
        }
        let sport = viewModel.sport
                viewModel.onStandingsUpdate = { [weak self] standings in
                    self?.standingsView.update(with: standings, sport: sport)
                }
        viewModel.onStandingsError = { [weak self] in
            self?.standingsView.showError()
        }
        standingsView.onTeamSelected = { [weak self] team in
            self?.openTeamDetails(for: team)
        }
        matchesView.onEventSelected = { [weak self] event in
            self?.openEventDetails(for: event)
        }
    }

    private func handleTabSelected(_ tab: TabIndex) {
        switch tab {
        case .first:
            matchesView.isHidden = false
            standingsView.isHidden = true
        case .second:
            matchesView.isHidden = true
            standingsView.isHidden = false
            viewModel.loadStandings()
        }
    }
    
    private func openTeamDetails(for team: Team) {
        let viewModel = TeamDetailsViewModel(team: team)
        let vc = TeamDetailsViewController(viewModel: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func openEventDetails(for event: Event) {
        let detailsViewModel = EventDetailsViewModel(event: event, sport: viewModel.sport)
        let vc = EventDetailsViewController(viewModel: detailsViewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
}
