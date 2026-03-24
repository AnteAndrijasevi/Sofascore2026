import UIKit
import SnapKit

final class MatchRowView: UIView {

    private enum Constants {
        static let logoSize: CGFloat = 16
        static let scoreLabelWidth: CGFloat = 20
        static let separatorHeight: CGFloat = 40
        static let timeStackWidth: CGFloat = 40
        static let spacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 16
    }

    private let timeLabel = UILabel()
    private let statusLabel = UILabel()
    private let timeStackView = UIStackView()
    private let separator = UIView()

    private let homeLogoImageView = UIImageView()
    private let awayLogoImageView = UIImageView()
    private let homeNameLabel = UILabel()
    private let awayNameLabel = UILabel()
    private let homeScoreLabel = UILabel()
    private let awayScoreLabel = UILabel()

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

        homeLogoImageView.contentMode = .scaleAspectFit
        homeLogoImageView.clipsToBounds = true

        awayLogoImageView.contentMode = .scaleAspectFit
        awayLogoImageView.clipsToBounds = true

        homeNameLabel.font = AppFonts.body
        homeNameLabel.textColor = AppColors.primaryText

        awayNameLabel.font = AppFonts.body
        awayNameLabel.textColor = AppColors.primaryText

        homeScoreLabel.font = AppFonts.body
        homeScoreLabel.textColor = AppColors.primaryText
        homeScoreLabel.textAlignment = .right

        awayScoreLabel.font = AppFonts.body
        awayScoreLabel.textColor = AppColors.primaryText
        awayScoreLabel.textAlignment = .right

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
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
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
            $0.leading.equalTo(separator.snp.trailing).offset(Constants.horizontalPadding)
            $0.trailing.equalToSuperview().offset(-Constants.horizontalPadding)
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
        statusLabel.textColor = viewModel.statusLabelColor
        homeNameLabel.text = viewModel.homeTeamName
        awayNameLabel.text = viewModel.awayTeamName
        homeScoreLabel.text = viewModel.homeScore
        awayScoreLabel.text = viewModel.awayScore

        homeLogoImageView.image = viewModel.homeTeamLogo
        awayLogoImageView.image = viewModel.awayTeamLogo

        homeNameLabel.textColor = viewModel.result?.homeTeamColor ?? AppColors.primaryText
        homeScoreLabel.textColor = viewModel.result?.homeTeamColor ?? AppColors.primaryText
        awayNameLabel.textColor = viewModel.result?.awayTeamColor ?? AppColors.primaryText
        awayScoreLabel.textColor = viewModel.result?.awayTeamColor ?? AppColors.primaryText
    }
}
