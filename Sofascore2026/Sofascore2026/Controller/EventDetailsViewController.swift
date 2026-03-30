import UIKit
import SnapKit

final class EventDetailsViewController: UIViewController {

    private enum Constants {
        static let teamLogoSize: CGFloat = 56
        static let horizontalPadding: CGFloat = 16
        static let teamStackSpacing: CGFloat = 8
        static let centerSpacing: CGFloat = 4
        static let cardVerticalPadding: CGFloat = 16
        static let titleLogoSize: CGFloat = 16
        static let titleLogoSpacing: CGFloat = 4
    }

    private let viewModel: EventDetailsViewModel

    private let titleLogoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let titleView = UIView()
    private let backButton = UIBarButtonItem()

    private let homeTeamStack = UIStackView()
    private let homeLogoImageView = UIImageView()
    private let homeNameLabel = UILabel()

    private let awayTeamStack = UIStackView()
    private let awayLogoImageView = UIImageView()
    private let awayNameLabel = UILabel()

    private let centerStack = UIStackView()

    private let dateLabel = UILabel()
    private let timeLabel = UILabel()

    private let scoreRow = UIStackView()
    private let homeScoreLabel = UILabel()
    private let dashLabel = UILabel()
    private let awayScoreLabel = UILabel()
    private let statusLabel = UILabel()

    private let teamsRow = UIStackView()
    private let separator = UIView()

    init(viewModel: EventDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure(with: viewModel)
        fetchImages()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            navigationController?.setNavigationBarHidden(true, animated: animated)
        }
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
        setupNavigationBar()
    }

    private func addViews() {
        view.addSubview(teamsRow)
        view.addSubview(separator)
        titleView.addSubview(titleLogoImageView)
        titleView.addSubview(titleLabel)

        homeTeamStack.addArrangedSubview(homeLogoImageView)
        homeTeamStack.addArrangedSubview(homeNameLabel)

        awayTeamStack.addArrangedSubview(awayLogoImageView)
        awayTeamStack.addArrangedSubview(awayNameLabel)

        scoreRow.addArrangedSubview(homeScoreLabel)
        scoreRow.addArrangedSubview(dashLabel)
        scoreRow.addArrangedSubview(awayScoreLabel)

        centerStack.addArrangedSubview(dateLabel)
        centerStack.addArrangedSubview(timeLabel)
        centerStack.addArrangedSubview(scoreRow)
        centerStack.addArrangedSubview(statusLabel)

        teamsRow.addArrangedSubview(homeTeamStack)
        teamsRow.addArrangedSubview(centerStack)
        teamsRow.addArrangedSubview(awayTeamStack)
    }

    private func styleViews() {
        view.backgroundColor = AppColors.surface

        titleLabel.font = AppFonts.caption
        titleLabel.textColor = AppColors.secondaryText

        titleLogoImageView.contentMode = .scaleAspectFit
        titleLogoImageView.clipsToBounds = true

        backButton.image = UIImage(named: AppStrings.icArrowLeft)?.withRenderingMode(.alwaysOriginal)
        backButton.style = .plain
        if #available(iOS 26.0, *) {
            backButton.hidesSharedBackground = true
        }

        homeTeamStack.axis = .vertical
        homeTeamStack.alignment = .center
        homeTeamStack.spacing = Constants.teamStackSpacing

        homeLogoImageView.contentMode = .scaleAspectFit
        homeLogoImageView.clipsToBounds = true

        homeNameLabel.font = AppFonts.headline
        homeNameLabel.textColor = AppColors.primaryText
        homeNameLabel.textAlignment = .center
        homeNameLabel.numberOfLines = 2

        awayTeamStack.axis = .vertical
        awayTeamStack.alignment = .center
        awayTeamStack.spacing = Constants.teamStackSpacing

        awayLogoImageView.contentMode = .scaleAspectFit
        awayLogoImageView.clipsToBounds = true

        awayNameLabel.font = AppFonts.headline
        awayNameLabel.textColor = AppColors.primaryText
        awayNameLabel.textAlignment = .center
        awayNameLabel.numberOfLines = 2

        centerStack.axis = .vertical
        centerStack.alignment = .center
        centerStack.spacing = Constants.centerSpacing

        dateLabel.font = AppFonts.caption
        dateLabel.textColor = AppColors.primaryText
        dateLabel.textAlignment = .center

        timeLabel.font = AppFonts.caption
        timeLabel.textColor = AppColors.primaryText
        timeLabel.textAlignment = .center

        scoreRow.axis = .horizontal
        scoreRow.alignment = .center
        scoreRow.spacing = Constants.centerSpacing

        homeScoreLabel.font = AppFonts.scoreboard
        homeScoreLabel.textAlignment = .center

        dashLabel.font = AppFonts.scoreboard
        dashLabel.textColor = AppColors.secondaryText
        dashLabel.textAlignment = .center
        awayScoreLabel.font = AppFonts.scoreboard
        awayScoreLabel.textAlignment = .center

        statusLabel.font = AppFonts.caption
        statusLabel.textAlignment = .center

        teamsRow.axis = .horizontal
        teamsRow.distribution = .fillEqually
        teamsRow.alignment = .center
        teamsRow.spacing = 0

        separator.backgroundColor = AppColors.separator
    }

    private func setupConstraints() {
        titleLogoImageView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
            $0.size.equalTo(Constants.titleLogoSize)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLogoImageView.snp.trailing).offset(Constants.titleLogoSpacing)
            $0.trailing.centerY.equalToSuperview()
        }

        titleView.snp.makeConstraints {
            $0.height.equalTo(Constants.titleLogoSize)
        }

        homeLogoImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.teamLogoSize)
        }

        awayLogoImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.teamLogoSize)
        }

        teamsRow.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(Constants.cardVerticalPadding)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
        }

        separator.snp.makeConstraints {
            $0.top.equalTo(teamsRow.snp.bottom).offset(Constants.cardVerticalPadding)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }

    private func setupNavigationBar() {
        backButton.target = self
        backButton.action = #selector(backTapped)
        navigationItem.titleView = titleView
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backButton
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    private func configure(with viewModel: EventDetailsViewModel) {
        titleLabel.text = viewModel.titleText
        dashLabel.text = AppStrings.scoreDash
        homeNameLabel.text = viewModel.homeTeamName
        awayNameLabel.text = viewModel.awayTeamName

        let hasScore = viewModel.homeScore != nil

        dateLabel.isHidden = hasScore
        timeLabel.isHidden = hasScore
        scoreRow.isHidden = !hasScore
        statusLabel.isHidden = !hasScore

        if hasScore {
            configureScore(with: viewModel)
        } else {
            dateLabel.text = viewModel.startDate
            timeLabel.text = viewModel.startTime
        }
    }

    private func configureScore(with viewModel: EventDetailsViewModel) {
        homeScoreLabel.text = viewModel.homeScore
        awayScoreLabel.text = viewModel.awayScore
        statusLabel.text = viewModel.statusLine

        homeScoreLabel.textColor = viewModel.homeScoreTextColor
        dashLabel.textColor = viewModel.dashTextColor
        awayScoreLabel.textColor = viewModel.awayScoreTextColor
        statusLabel.textColor = viewModel.statusTextColor
    }

    private func fetchImages() {
        viewModel.fetchImages { [weak self] in
            guard let self else { return }
            homeLogoImageView.image = viewModel.homeTeamLogo
            awayLogoImageView.image = viewModel.awayTeamLogo
            titleLogoImageView.image = viewModel.leagueLogo
        }
    }
}
