import UIKit
import SnapKit

final class LeagueHeaderView: UIView {

    private enum Constants {
        static let logoSize: CGFloat = 32
        static let horizontalPadding: CGFloat = 16

    }

    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.headline
        label.textColor = AppColors.primaryText
        return label
    }()

    private let arrowImageView = UIImageView(named: "ic_pointer_right")

    private let leagueNameLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColors.secondaryText
        return label
    }()

    private let textStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 4
        sv.alignment = .center
        return sv
    }()

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
        textStackView.addArrangedSubview(countryLabel)
        textStackView.addArrangedSubview(arrowImageView)
        textStackView.addArrangedSubview(leagueNameLabel)
        addSubview(logoImageView)
        addSubview(textStackView)
    }

    private func styleViews() {
        backgroundColor = AppColors.surface
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
