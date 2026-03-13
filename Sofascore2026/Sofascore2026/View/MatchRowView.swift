import UIKit
import SnapKit

final class MatchRowView: UIView {

    private enum Constants {
        static let logoSize: CGFloat = 16
        static let scoreLabelWidth: CGFloat = 20
        static let separatorWidth: CGFloat = 1
        static let separatorHeight: CGFloat = 40
        static let timeStackWidth: CGFloat = 40
        static let timeStackLeading: CGFloat = 4
        static let spacing: CGFloat = 8
        static let teamsSpacing: CGFloat = 4
    }

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.textAlignment = .center
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.textAlignment = .center
        return label
    }()

    private let timeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.separator
        return view
    }()

    private let homeLogoImageView = MatchRowView.makeTeamLogo()
    private let awayLogoImageView = MatchRowView.makeTeamLogo()
    private let homeNameLabel = MatchRowView.makeTeamNameLabel()
    private let awayNameLabel = MatchRowView.makeTeamNameLabel()
    private let homeScoreLabel = MatchRowView.makeScoreLabel()
    private let awayScoreLabel = MatchRowView.makeScoreLabel()

    private let homeRowStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()

    private let awayRowStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()

    private let teamsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.distribution = .fillEqually
        return sv
    }()

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
        timeStackView.addArrangedSubview(timeLabel)
        timeStackView.addArrangedSubview(statusLabel)

        homeRowStack.addArrangedSubview(homeLogoImageView)
        homeRowStack.addArrangedSubview(homeNameLabel)
        homeRowStack.addArrangedSubview(homeScoreLabel)

        awayRowStack.addArrangedSubview(awayLogoImageView)
        awayRowStack.addArrangedSubview(awayNameLabel)
        awayRowStack.addArrangedSubview(awayScoreLabel)

        teamsStackView.addArrangedSubview(homeRowStack)
        teamsStackView.addArrangedSubview(awayRowStack)

        addSubview(timeStackView)
        addSubview(separator)
        addSubview(teamsStackView)
    }

    private func styleViews() {
        backgroundColor = AppColors.surface
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
            $0.width.equalTo(Constants.separatorWidth)
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
