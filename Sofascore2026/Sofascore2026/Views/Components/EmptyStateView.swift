import UIKit
import SnapKit

final class EmptyStateView: UIView {

    private let messageLabel = UILabel()

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
        addSubview(messageLabel)
    }

    private func styleViews() {
        backgroundColor = .clear
        isHidden = true

        messageLabel.font = AppFonts.caption
        messageLabel.textColor = AppColors.liveRed
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
    }

    private func setupConstraints() {
        messageLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }
    }

    func show(_ message: String = AppStrings.errorMessage) {
        messageLabel.text = message
        isHidden = false
    }

    func hide() {
        isHidden = true
    }
}
