import UIKit
import SnapKit

final class LeagueStandingsHeaderView: UIView {

    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let spacing: CGFloat = 8
    }

    private let positionLabel = UILabel()
    private let teamLabel = UILabel()
    private let statsStackView = UIStackView()

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
        addSubview(positionLabel)
        addSubview(teamLabel)
        addSubview(statsStackView)
    }

    private func styleViews() {
        backgroundColor = AppColors.surface

        positionLabel.text = AppStrings.positionColumn
        positionLabel.font = AppFonts.caption
        positionLabel.textColor = AppColors.secondaryText
        positionLabel.textAlignment = .center

        teamLabel.text = AppStrings.teamColumn
        teamLabel.font = AppFonts.caption
        teamLabel.textColor = AppColors.secondaryText

        statsStackView.axis = .horizontal
        statsStackView.spacing = Constants.spacing
        statsStackView.alignment = .center
        statsStackView.distribution = .fill
    }

    private func setupConstraints() {
        positionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(StandingsColumn.positionSize)
        }

        teamLabel.snp.makeConstraints {
            $0.leading.equalTo(positionLabel.snp.trailing).offset(Constants.spacing)
            $0.centerY.equalToSuperview()
        }

        statsStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
        }
    }

    func configure(for sport: Sport) {
        statsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        for column in StandingsColumn.columns(for: sport) {
            let label = makeColumnLabel(title: column.title)
            statsStackView.addArrangedSubview(label)
            label.snp.makeConstraints {
                $0.width.equalTo(column.width)
            }
        }
    }
    
    private func makeColumnLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.textAlignment = .center
        return label
    }
}
