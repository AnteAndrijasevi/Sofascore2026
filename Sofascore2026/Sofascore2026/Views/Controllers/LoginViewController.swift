import UIKit
import SnapKit

final class LoginViewController: UIViewController {

    private enum Constants {
        static let fieldHeight: CGFloat = 52
        static let cornerRadius: CGFloat = 10
    }
    
    private let viewModel = LoginViewModel()
    private let onLoginSuccess: () -> Void

    private let logoImageView = UIImageView(named: AppStrings.icTitle)
    private let usernameField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let errorLabel = UILabel()
    private let stackView = UIStackView()

    init(onLoginSuccess: @escaping () -> Void) {
        self.onLoginSuccess = onLoginSuccess
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
        setupActions()
    }

    private func addViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(logoImageView)
        stackView.addArrangedSubview(usernameField)
        stackView.addArrangedSubview(passwordField)
        stackView.addArrangedSubview(loginButton)
        stackView.addArrangedSubview(errorLabel)
    }

    private func styleViews() {
        view.backgroundColor = AppColors.primary

        styleField(usernameField, placeholder: AppStrings.usernamePlaceholder)
        styleField(passwordField, placeholder: AppStrings.passwordPlaceholder)
        passwordField.isSecureTextEntry = true

        loginButton.setTitle(AppStrings.loginButton, for: .normal)
        loginButton.setTitleColor(AppColors.primary, for: .normal)
        loginButton.titleLabel?.font = AppFonts.headline
        loginButton.backgroundColor = AppColors.onPrimary
        loginButton.layer.cornerRadius = Constants.cornerRadius

        errorLabel.font = AppFonts.caption
        errorLabel.textColor = AppColors.onPrimary
        errorLabel.textAlignment = .center
        errorLabel.numberOfLines = 0
        errorLabel.isHidden = true

        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.setCustomSpacing(40, after: logoImageView)
    }

    private func styleField(_ field: UITextField, placeholder: String) {
        field.font = AppFonts.body
        field.textColor = AppColors.primaryText
        field.backgroundColor = AppColors.onPrimary
        field.layer.cornerRadius = Constants.cornerRadius
        field.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: AppColors.secondaryText]
        )
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 0))
        field.leftViewMode = .always
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }

        logoImageView.snp.makeConstraints {
            $0.height.equalTo(40)
        }

        usernameField.snp.makeConstraints {
            $0.height.equalTo(Constants.fieldHeight)
        }

        passwordField.snp.makeConstraints {
            $0.height.equalTo(Constants.fieldHeight)
        }

        loginButton.snp.makeConstraints {
            $0.height.equalTo(Constants.fieldHeight)
        }
    }

    private func setupActions() {
        loginButton.addTarget(self, action: #selector(loginTapped), for: .touchUpInside)
    }

    @objc private func loginTapped() {
        let username = usernameField.text ?? ""
        let password = passwordField.text ?? ""

        guard !username.isEmpty, !password.isEmpty else {
            showError(AppStrings.loginEmptyFields)
            return
        }

        loginButton.isEnabled = false
        errorLabel.isHidden = true

        Task { @MainActor [weak self] in
            guard let self else { return }
            do {
                try await viewModel.login(username: username, password: password)
                onLoginSuccess()
            } catch {
                showError(AppStrings.loginFailed)
                loginButton.isEnabled = true
            }
        }
    }

    private func showError(_ message: String) {
        errorLabel.text = message
        errorLabel.isHidden = false
    }
}
