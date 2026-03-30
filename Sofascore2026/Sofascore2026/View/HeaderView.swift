import UIKit
import SnapKit

final class HeaderView: UIView {

    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let iconSize: CGFloat = 24
        static let iconSpacing: CGFloat = 16
    }

    private let onSettingsTapped: () -> Void
    private let titleImageView = UIImageView()
    private let trophyImageView = UIImageView()
    private let settingsButton = UIButton(type: .system)

    init(onSettingsTapped: @escaping () -> Void) {
        self.onSettingsTapped = onSettingsTapped
        super.init(frame: .zero)
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
        addSubview(titleImageView)
        addSubview(trophyImageView)
        addSubview(settingsButton)
    }

    private func styleViews() {
        backgroundColor = AppColors.primary

        titleImageView.image = UIImage(named: AppStrings.icTitle)
        titleImageView.contentMode = .scaleAspectFit

        trophyImageView.image = UIImage(named: AppStrings.icTrophy)
        trophyImageView.contentMode = .scaleAspectFit

        settingsButton.setImage(
            UIImage(named: AppStrings.icSettings)?.withRenderingMode(.alwaysOriginal),
            for: .normal
        )
        settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        titleImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(Constants.iconSize)
        }

        settingsButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Constants.iconSize)
        }

        trophyImageView.snp.makeConstraints {
            $0.trailing.equalTo(settingsButton.snp.leading).offset(-Constants.iconSpacing)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Constants.iconSize)
        }
    }

    @objc private func settingsTapped() {
        onSettingsTapped()
    }
}
