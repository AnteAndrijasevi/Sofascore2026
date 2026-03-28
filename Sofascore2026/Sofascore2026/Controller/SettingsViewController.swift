import UIKit

final class SettingsViewController: UIViewController {

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
    }

    private func setupConstraints() {}

    private func setupNavigationBar() {
        title = AppStrings.settings
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate),
            style: .plain,
            target: self,
            action: #selector(dismissTapped)
        )
        navigationController?.navigationBar.tintColor = AppColors.primaryText
    }

    @objc private func dismissTapped() {
        dismiss(animated: true)
    }
}
