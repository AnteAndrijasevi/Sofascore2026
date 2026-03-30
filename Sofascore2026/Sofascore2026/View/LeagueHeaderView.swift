import UIKit
import SnapKit

final class LeagueHeaderView: UITableViewHeaderFooterView {

    static let identifier = "LeagueHeaderView"

    private enum Constants {
        static let logoSize: CGFloat = 32
        static let horizontalPadding: CGFloat = 16
        static let separatorOverlap: CGFloat = 8
    }

    private let topSeparator = UIView()
    private let logoImageView = UIImageView()
    private let countryLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let leagueNameLabel = UILabel()
    private let textStackView = UIStackView()

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
        contentView.addSubview(topSeparator)
        contentView.addSubview(logoImageView)
        contentView.addSubview(textStackView)
        textStackView.addArrangedSubview(countryLabel)
        textStackView.addArrangedSubview(arrowImageView)
        textStackView.addArrangedSubview(leagueNameLabel)
    }

    private func styleViews() {
        contentView.backgroundColor = AppColors.surface
        topSeparator.backgroundColor = AppColors.separator

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.clipsToBounds = true

        countryLabel.font = AppFonts.headline
        countryLabel.textColor = AppColors.primaryText

        leagueNameLabel.font = AppFonts.body
        leagueNameLabel.textColor = AppColors.secondaryText

        textStackView.axis = .horizontal
        textStackView.spacing = 4
        textStackView.alignment = .center

        arrowImageView.image = UIImage(named: AppStrings.icPointerRight)
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
        
        topSeparator.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().offset(-Constants.separatorOverlap)
            $0.height.equalTo(1)
        }
    }

    func showSeparator(_ show: Bool) {
        topSeparator.isHidden = !show
    }

    func configure(with viewModel: LeagueHeaderViewModel) {
        countryLabel.text = viewModel.countryName
        leagueNameLabel.text = viewModel.leagueName
        logoImageView.image = viewModel.logoImage
    }
}
