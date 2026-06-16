import UIKit
import SnapKit

final class SettingsViewController: UIViewController {

    private let onLogout: () -> Void
    private let viewModel = SettingsViewModel()

    private let dismissButton = UIBarButtonItem()
    private let avatarImageView = UIImageView()
    private let captionLabel = UILabel()
    private let nameLabel = UILabel()
    private let logoutButton = UIButton(type: .system)
    private let stackView = UIStackView()
    private let countLabel = UILabel()

    init(onLogout: @escaping () -> Void) {
        self.onLogout = onLogout
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
            super.viewDidLoad()
            setupUI()
            viewModel.onCountsUpdate = { [weak self] in
                guard let self else { return }
                countLabel.text = viewModel.countText
            }
            viewModel.loadCounts()
        }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
        setupNavigationBar()
        setupActions()
    }

    private func addViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(avatarImageView)
        stackView.addArrangedSubview(captionLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(countLabel)
        stackView.addArrangedSubview(logoutButton)
    }

    private func styleViews() {
        view.backgroundColor = AppColors.primary

        avatarImageView.image = UIImage(systemName: AppStrings.icProfileSymbol)?
            .withRenderingMode(.alwaysTemplate)
        avatarImageView.tintColor = AppColors.onPrimary
        avatarImageView.contentMode = .scaleAspectFit

        captionLabel.text = AppStrings.loggedInAs
        captionLabel.font = AppFonts.caption
        captionLabel.textColor = AppColors.onPrimary.withAlphaComponent(0.7)
        captionLabel.textAlignment = .center

        nameLabel.text = viewModel.userName
        nameLabel.font = AppFonts.scoreboard
        nameLabel.textColor = AppColors.onPrimary
        nameLabel.textAlignment = .center

        logoutButton.setTitle(AppStrings.logoutButton, for: .normal)
        logoutButton.setTitleColor(AppColors.primary, for: .normal)
        logoutButton.titleLabel?.font = AppFonts.headline
        logoutButton.backgroundColor = AppColors.onPrimary
        logoutButton.layer.cornerRadius = 10

        dismissButton.image = UIImage(systemName: AppStrings.icCloseSymbol)?.withRenderingMode(.alwaysTemplate)
        dismissButton.style = .plain

        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8
        stackView.setCustomSpacing(40, after: countLabel)

        countLabel.font = AppFonts.subtitle
        countLabel.textColor = AppColors.onPrimary.withAlphaComponent(0.7)
        countLabel.textAlignment = .center
        countLabel.numberOfLines = 0
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        avatarImageView.snp.makeConstraints {
            $0.size.equalTo(72)
        }

        logoutButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(52)
        }
    }

    private func setupNavigationBar() {
        title = AppStrings.settings
        dismissButton.target = self
        dismissButton.action = #selector(dismissTapped)
        navigationItem.leftBarButtonItem = dismissButton
    }

    private func setupActions() {
        logoutButton.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
    }

    @objc private func dismissTapped() {
        dismiss(animated: true)
    }

    @objc private func logoutTapped() {
        viewModel.logout()
        dismiss(animated: true) { [weak self] in
            self?.onLogout()
        }
    }
}
