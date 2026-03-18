import UIKit
import SnapKit

final class LeagueHeaderView: UIView {

    private enum Constants {
        static let logoSize: CGFloat = 32
        static let horizontalPadding: CGFloat = 16
    }

    private let logoImageView = UIImageView()
    private let countryLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let leagueNameLabel = UILabel()
    private let textStackView = UIStackView()

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
        addSubview(logoImageView)
        addSubview(textStackView)
        textStackView.addArrangedSubview(countryLabel)
        textStackView.addArrangedSubview(arrowImageView)
        textStackView.addArrangedSubview(leagueNameLabel)
    }

    private func styleViews() {
        backgroundColor = AppColors.surface

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true

        countryLabel.font = AppFonts.headline
        countryLabel.textColor = AppColors.primaryText

        leagueNameLabel.font = AppFonts.body
        leagueNameLabel.textColor = AppColors.secondaryText

        textStackView.axis = .horizontal
        textStackView.spacing = 4
        textStackView.alignment = .center
        
        arrowImageView.image = UIImage(named: "ic_pointer_right")
        arrowImageView.contentMode = .scaleAspectFit
    }

    private func setupConstraints() {
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Constants.logoSize)
        }

        textStackView.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().offset(-Constants.horizontalPadding)
        }
    }

    func configure(with viewModel: LeagueHeaderViewModel) {
        countryLabel.text = viewModel.countryName
        leagueNameLabel.text = viewModel.leagueName
        logoImageView.image = viewModel.logoImage
    }
}
