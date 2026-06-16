import UIKit
import SnapKit

final class LeagueStandingsCell: UITableViewCell {

    static let identifier = "LeagueStandingsCell"

    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let spacing: CGFloat = 8
    }

    private let positionLabel = UILabel()
    private let teamNameLabel = UILabel()
    private let statsStackView = UIStackView()
    
    private var configuredSport: Sport?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        contentView.addSubview(positionLabel)
        contentView.addSubview(teamNameLabel)
        contentView.addSubview(statsStackView)
    }

    private func styleViews() {
        selectionStyle = .none
        backgroundColor = AppColors.surface

        positionLabel.font = AppFonts.body
        positionLabel.textColor = AppColors.primaryText
        positionLabel.textAlignment = .center
        positionLabel.backgroundColor = AppColors.roundSectionBackground
        positionLabel.layer.cornerRadius = StandingsColumn.positionSize / 2
        positionLabel.layer.masksToBounds = true

        teamNameLabel.font = AppFonts.body
        teamNameLabel.textColor = AppColors.primaryText
        teamNameLabel.lineBreakMode = .byTruncatingTail

        statsStackView.axis = .horizontal
        statsStackView.spacing = Constants.spacing
        statsStackView.alignment = .center
        statsStackView.distribution = .fill
    }

    private func setupConstraints() {
        positionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(StandingsColumn.positionSize)
        }

        teamNameLabel.snp.makeConstraints {
            $0.leading.equalTo(positionLabel.snp.trailing).offset(Constants.spacing)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualTo(statsStackView.snp.leading).offset(-Constants.spacing)
        }

        teamNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        teamNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        statsStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
    }

    func configure(with standing: LeagueStanding, sport: Sport) {
        positionLabel.text = "\(standing.position)"
        teamNameLabel.text = standing.team.name

        let columns = StandingsColumn.columns(for: sport)

        if configuredSport != sport {
            configuredSport = sport
            statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
            for column in columns {
                let label = makeStatLabel(value: "")
                statsStackView.addArrangedSubview(label)
                label.snp.makeConstraints {
                    $0.width.equalTo(column.width)
                }
            }
        }

        for case let (label as UILabel, column) in zip(statsStackView.arrangedSubviews, columns) {
            label.text = column.value(for: standing)
        }
    }
    



    private func makeStatLabel(value: String) -> UILabel {
            let label = UILabel()
            label.text = value
            label.font = AppFonts.body
            label.textColor = AppColors.primaryText
            label.textAlignment = .center
            return label
    }
}
