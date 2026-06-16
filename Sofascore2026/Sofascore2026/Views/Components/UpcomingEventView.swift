import UIKit
import SnapKit

final class UpcomingEventView: UIView {

    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let buttonHorizontalPadding: CGFloat = 24
    }

    var onViewTournamentDetails: (() -> Void)?

    private let whiteContainer = UIView()
    private let card = UIView()
    private let messageLabel = UILabel()
    private let detailsButton = UIButton(type: .system)

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
        setupActions()
    }

    private func addViews() {
        addSubview(whiteContainer)
        whiteContainer.addSubview(card)
        card.addSubview(messageLabel)
        whiteContainer.addSubview(detailsButton)
    }

    private func styleViews() {
        backgroundColor = AppColors.roundSectionBackground

        whiteContainer.backgroundColor = AppColors.surface

        card.backgroundColor = AppColors.roundSectionBackground
        card.layer.cornerRadius = 12

        messageLabel.text = AppStrings.noIncidents
        messageLabel.font = AppFonts.body
        messageLabel.textColor = AppColors.secondaryText
        messageLabel.textAlignment = .center

        var config = UIButton.Configuration.plain()

        var titleContainer = AttributeContainer()
        titleContainer.font = AppFonts.button
        config.attributedTitle = AttributedString(
            AppStrings.viewTournamentDetails,
            attributes: titleContainer
        )

        config.baseForegroundColor = AppColors.primary
        config.background.backgroundColor = AppColors.surface
        config.background.strokeColor = AppColors.primary
        config.background.strokeWidth = 2
        config.background.cornerRadius = 0
        config.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: Constants.buttonHorizontalPadding,
            bottom: 0,
            trailing: Constants.buttonHorizontalPadding
        )

        detailsButton.configuration = config
    }

    private func setupConstraints() {
        whiteContainer.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }

        card.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
        }

        messageLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(20)
            $0.leading.trailing.equalToSuperview().inset(Constants.horizontalPadding)
        }

        detailsButton.snp.makeConstraints {
            $0.top.equalTo(card.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.leading.greaterThanOrEqualToSuperview().offset(Constants.horizontalPadding)
            $0.trailing.lessThanOrEqualToSuperview().inset(Constants.horizontalPadding)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().inset(24)
        }
    }

    private func setupActions() {
        detailsButton.addTarget(self, action: #selector(detailsTapped), for: .touchUpInside)
    }

    @objc private func detailsTapped() {
        onViewTournamentDetails?()
    }
}
