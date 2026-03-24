import UIKit
import SnapKit

final class SportSelectorItemView: UIButton {

    private let iconImageView = UIImageView()
    private let sportTitleLabel = UILabel()
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
        stackView.addArrangedSubview(sportTitleLabel)
    }

    private func styleViews() {
        sportTitleLabel.font = AppFonts.headline
        sportTitleLabel.textColor = AppColors.onPrimary
        sportTitleLabel.textAlignment = .center

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = AppColors.onPrimary

        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .center

        selectorBar.backgroundColor = .clear
        selectorBar.layer.cornerRadius = 1
        
        stackView.isUserInteractionEnabled = false
        selectorBar.isUserInteractionEnabled = false
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(selectorBar.snp.top).offset(-8)
        }

        iconImageView.snp.makeConstraints {
            $0.size.equalTo(16)
        }

        selectorBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(2)
            $0.height.equalTo(4)
        }
    }

    func configure(with sport: Sport, isSelected: Bool) {
        sportTitleLabel.text = sport.title
        iconImageView.image = UIImage(named: sport.iconName)
        selectorBar.backgroundColor = isSelected ? AppColors.onPrimary : .clear
    }
}
