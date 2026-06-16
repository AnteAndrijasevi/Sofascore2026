import UIKit
import SnapKit

final class DetailsHeaderView: UIView {

    private enum Constants {
        static let horizontalPadding: CGFloat = 16
    }

    private let backButton = UIButton(type: .system)
    private let logoImageView = UIImageView()
    private let nameLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let tabSelectorView: TabSelectorView
    private let subtitleBold: Bool
    private let onBack: () -> Void

    init(
        title: String,
        subtitle: String?,
        tabTitles: [String],
        subtitleBold: Bool = false,
        onBack: @escaping () -> Void,
        onTabSelected: @escaping (TabIndex) -> Void
    ) {
        self.subtitleBold = subtitleBold
        self.onBack = onBack
        self.tabSelectorView = TabSelectorView(titles: tabTitles, onTabSelected: onTabSelected)
        super.init(frame: .zero)
        nameLabel.text = title
        subtitleLabel.text = subtitle
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setLogo(_ image: UIImage?) {
        logoImageView.image = image
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
        setupActions()
    }

    private func addViews() {
        addSubview(backButton)
        addSubview(logoImageView)
        addSubview(nameLabel)
        addSubview(subtitleLabel)
        addSubview(tabSelectorView)
    }

    private func styleViews() {
        backgroundColor = AppColors.primary

        backButton.setImage(
            UIImage(named: AppStrings.icArrowLeft)?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        backButton.tintColor = AppColors.onPrimary

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.backgroundColor = AppColors.onPrimary
        logoImageView.layer.cornerRadius = 8
        logoImageView.clipsToBounds = true

        nameLabel.font = AppFonts.scoreboard
        nameLabel.textColor = AppColors.onPrimary

        subtitleLabel.font = subtitleBold ? AppFonts.headline : AppFonts.caption
        subtitleLabel.textColor = AppColors.onPrimary
    }

    private func setupConstraints() {
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(8)
            $0.size.equalTo(32)
        }

        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.top.equalTo(backButton.snp.bottom).offset(8)
            $0.size.equalTo(48)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(12)
            $0.bottom.equalTo(logoImageView.snp.centerY).offset(2)
            $0.trailing.lessThanOrEqualToSuperview().inset(Constants.horizontalPadding)
        }

        subtitleLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(4)
        }

        tabSelectorView.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(56)
            $0.bottom.equalToSuperview()
        }
    }

    private func setupActions() {
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
    }

    @objc private func backTapped() {
        onBack()
    }
}
