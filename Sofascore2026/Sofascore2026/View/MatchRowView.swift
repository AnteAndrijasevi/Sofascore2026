import UIKit
import SnapKit

final class MatchRowView: UIView {

    private enum Constants {
        static let logoSize: CGFloat = 16
        static let scoreLabelWidth: CGFloat = 20
        static let separatorHeight: CGFloat = 40
        static let timeStackWidth: CGFloat = 40
        static let timeStackLeading: CGFloat = 4
        static let spacing: CGFloat = 8
    }

    private let timeLabel = UILabel()
    private let statusLabel = UILabel()
    private let timeStackView = UIStackView()
    private let separator = UIView()

    private let homeLogoImageView = MatchRowView.makeTeamLogo()
    private let awayLogoImageView = MatchRowView.makeTeamLogo()
    private let homeNameLabel = MatchRowView.makeTeamNameLabel()
    private let awayNameLabel = MatchRowView.makeTeamNameLabel()
    private let homeScoreLabel = MatchRowView.makeScoreLabel()
    private let awayScoreLabel = MatchRowView.makeScoreLabel()

    private let homeRowStack = UIStackView()
    private let awayRowStack = UIStackView()
    private let teamsStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func makeTeamLogo() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }

    private static func makeTeamNameLabel() -> UILabel {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColors.primaryText
        return label
    }

    private static func makeScoreLabel() -> UILabel {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColors.primaryText
        label.textAlignment = .right
        return label
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
    }

    private func addViews() {
        addSubview(timeStackView)
        addSubview(separator)
        addSubview(teamsStackView)

        timeStackView.addArrangedSubview(timeLabel)
        timeStackView.addArrangedSubview(statusLabel)

        teamsStackView.addArrangedSubview(homeRowStack)
        teamsStackView.addArrangedSubview(awayRowStack)

        homeRowStack.addArrangedSubview(homeLogoImageView)
        homeRowStack.addArrangedSubview(homeNameLabel)
        homeRowStack.addArrangedSubview(homeScoreLabel)

        awayRowStack.addArrangedSubview(awayLogoImageView)
        awayRowStack.addArrangedSubview(awayNameLabel)
        awayRowStack.addArrangedSubview(awayScoreLabel)
    }

    private func styleViews() {
        backgroundColor = AppColors.surface

        timeLabel.font = AppFonts.caption
        timeLabel.textColor = AppColors.secondaryText
        timeLabel.textAlignment = .center

        statusLabel.font = AppFonts.caption
        statusLabel.textColor = AppColors.secondaryText
        statusLabel.textAlignment = .center

        timeStackView.axis = .vertical
        timeStackView.spacing = 2
        timeStackView.alignment = .center
        timeStackView.distribution = .fillEqually

        separator.backgroundColor = AppColors.separator

        homeRowStack.axis = .horizontal
        homeRowStack.spacing = Constants.spacing
        homeRowStack.alignment = .center

        awayRowStack.axis = .horizontal
        awayRowStack.spacing = Constants.spacing
        awayRowStack.alignment = .center

        teamsStackView.axis = .vertical
        teamsStackView.spacing = 4
        teamsStackView.distribution = .fillEqually
    }

    private func setupConstraints() {
        timeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.timeStackLeading)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Constants.timeStackWidth)
        }

        separator.snp.makeConstraints {
            $0.leading.equalTo(timeStackView.snp.trailing).offset(Constants.spacing)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(Constants.separatorHeight)
        }

        teamsStackView.snp.makeConstraints {
            $0.leading.equalTo(separator.snp.trailing).offset(Constants.spacing)
            $0.trailing.equalToSuperview().offset(-Constants.spacing)
            $0.centerY.equalToSuperview()
        }

        homeLogoImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.logoSize)
        }

        awayLogoImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.logoSize)
        }

        homeScoreLabel.snp.makeConstraints {
            $0.width.equalTo(Constants.scoreLabelWidth)
        }

        awayScoreLabel.snp.makeConstraints {
            $0.width.equalTo(Constants.scoreLabelWidth)
        }
    }

    func configure(with viewModel: MatchRowViewModel) {
        timeLabel.text = viewModel.timeOrStatus
        statusLabel.text = viewModel.statusLine
        statusLabel.textColor = viewModel.isLive ? AppColors.liveRed : AppColors.secondaryText

        homeNameLabel.text = viewModel.homeTeamName
        awayNameLabel.text = viewModel.awayTeamName
        homeScoreLabel.text = viewModel.homeScore
        awayScoreLabel.text = viewModel.awayScore

        homeLogoImageView.image = viewModel.homeTeamLogo
        awayLogoImageView.image = viewModel.awayTeamLogo

        if let isDraw = viewModel.isDraw, isDraw {
            homeNameLabel.textColor = AppColors.primaryText
            homeScoreLabel.textColor = AppColors.primaryText
            awayNameLabel.textColor = AppColors.primaryText
            awayScoreLabel.textColor = AppColors.primaryText
        } else if let homeWon = viewModel.homeWon {
            homeNameLabel.textColor = homeWon ? AppColors.primaryText : AppColors.secondaryText
            homeScoreLabel.textColor = homeWon ? AppColors.primaryText : AppColors.secondaryText
            awayNameLabel.textColor = homeWon ? AppColors.secondaryText : AppColors.primaryText
            awayScoreLabel.textColor = homeWon ? AppColors.secondaryText : AppColors.primaryText
        }
    }
}
