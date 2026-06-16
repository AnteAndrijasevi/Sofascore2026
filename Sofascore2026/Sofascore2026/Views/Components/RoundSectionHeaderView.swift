import UIKit
import SnapKit

final class RoundSectionHeaderView: UITableViewHeaderFooterView {

    static let identifier = "RoundSectionHeaderView"

    private let titleLabel = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
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
        contentView.addSubview(titleLabel)
    }

    private func styleViews() {
        contentView.backgroundColor = AppColors.roundSectionBackground
        titleLabel.font = AppFonts.headline
        titleLabel.textColor = AppColors.primaryText
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }

    func configure(title: String) {
        titleLabel.text = title
    }
}
