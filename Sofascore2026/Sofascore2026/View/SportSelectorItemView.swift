import UIKit
import SnapKit

final class SportSelectorItemView: UIView {

    private enum Constants {
        static let iconSize: CGFloat = 24
        static let selectorHeight: CGFloat = 2
        static let verticalPadding: CGFloat = 8
    }

    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let selectorBar = UIView()
    private let stackView = UIStackView()

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
        addSubview(stackView)
        addSubview(selectorBar)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(titleLabel)
    }

    private func styleViews() {
        titleLabel.font = AppFonts.headline
        titleLabel.textColor = AppColors.onPrimary
        iconImageView.tintColor = AppColors.onPrimary
        titleLabel.textAlignment = .center

        iconImageView.contentMode = .scaleAspectFit

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center

        selectorBar.backgroundColor = .clear
        selectorBar.layer.cornerRadius = 1
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Constants.verticalPadding)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(selectorBar.snp.top).offset(-Constants.verticalPadding)
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(Constants.iconSize)
        }

        selectorBar.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Constants.selectorHeight)
        }
    }

    func configure(with sport: Sport, isSelected: Bool) {
        titleLabel.text = sport.title
        iconImageView.image = UIImage(named: sport.iconName)
        selectorBar.backgroundColor = isSelected ? AppColors.onPrimary : .clear
    }
}
