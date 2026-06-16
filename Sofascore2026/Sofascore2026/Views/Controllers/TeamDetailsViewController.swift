import UIKit
import SnapKit

final class TeamDetailsViewController: UIViewController {

    private let viewModel: TeamDetailsViewModel

    private lazy var headerView = DetailsHeaderView(
        title: viewModel.teamName,
        subtitle: viewModel.countryName,
        tabTitles: [AppStrings.detailsTab, AppStrings.playersTab],
        onBack: { [weak self] in self?.backTapped() },
        onTabSelected: { [weak self] tab in self?.handleTabSelected(tab) }
    )

    private let detailsView = TeamDetailsView()
    private let playersView = TeamPlayersView()

    init(viewModel: TeamDetailsViewModel) {
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
        viewModel.loadDetails()
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
            view.addSubview(detailsView)
            view.addSubview(playersView)
        }

    private func styleViews() {
            view.backgroundColor = AppColors.surface
            playersView.isHidden = true
        }

    private func setupConstraints() {
        headerView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        detailsView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        playersView.snp.makeConstraints {
            $0.edges.equalTo(detailsView)
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
        viewModel.onDetailsUpdate = { [weak self] in
        guard let self else { return }
        detailsView.update(
            coachName: viewModel.managerName,
            coachCountry: viewModel.managerCountryName,
            coachImage: viewModel.managerImage,
            playersCount: viewModel.playersCount,
            tournaments: viewModel.tournaments,
            tournamentLogos: viewModel.tournamentLogos,
            venueName: viewModel.venueName
            )
        }
        
        viewModel.onDetailsError = { [weak self] in
            self?.detailsView.showError()
        }
        viewModel.onPlayersUpdate = { [weak self] players in
            self?.playersView.update(with: players)
        }
        viewModel.onPlayersError = { [weak self] in
            self?.playersView.showError()
        }
    }

    private func handleTabSelected(_ tab: TabIndex) {
        switch tab {
        case .first:
            detailsView.isHidden = false
            playersView.isHidden = true
        case .second:
            detailsView.isHidden = true
            playersView.isHidden = false
            viewModel.loadPlayers()
        }
    }
}
