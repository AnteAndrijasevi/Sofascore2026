import UIKit

final class SettingsViewController: UIViewController {

    private let dismissButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
        setupNavigationBar()
    }

    private func addViews() {}

    private func styleViews() {
        view.backgroundColor = AppColors.surface
        dismissButton.image = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate)
        dismissButton.style = .plain
        navigationController?.navigationBar.tintColor = AppColors.primaryText
    }

    private func setupConstraints() {}

    private func setupNavigationBar() {
        title = AppStrings.settings
        dismissButton.target = self
        dismissButton.action = #selector(dismissTapped)
        navigationItem.leftBarButtonItem = dismissButton
    }

    @objc private func dismissTapped() {
        dismiss(animated: true)
    }
}
