import UIKit
import SnapKit

final class LeagueHeaderView: UITableViewHeaderFooterView {

    static let identifier = "LeagueHeaderView"

    private var currentViewModel: LeagueHeaderViewModel?
    var onTapped: (() -> Void)?

    private enum Constants {
        static let horizontalPadding: CGFloat = 16
    }

    private let topSeparator = UIView()
    private let logoImageView = UIImageView()
    private let countryLabel = UILabel()
    private let arrowImageView = UIImageView(named: AppStrings.icPointerRight)
    private let leagueNameLabel = UILabel()
    private let textStackView = UIStackView()
    private let overlayButton = UIButton(type: .custom)

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
        setupActions()
    }

    private func addViews() {
        contentView.addSubview(topSeparator)
        contentView.addSubview(logoImageView)
        contentView.addSubview(textStackView)
        textStackView.addArrangedSubview(countryLabel)
        textStackView.addArrangedSubview(arrowImageView)
        textStackView.addArrangedSubview(leagueNameLabel)
        contentView.addSubview(overlayButton)
        }

    private func styleViews() {
        contentView.backgroundColor = AppColors.surface
        topSeparator.backgroundColor = AppColors.separator

        logoImageView.contentMode = .scaleAspectFit

        countryLabel.font = AppFonts.headline
        countryLabel.textColor = AppColors.primaryText

        leagueNameLabel.font = AppFonts.body
        leagueNameLabel.textColor = AppColors.secondaryText

        textStackView.axis = .horizontal
        textStackView.spacing = 4
        textStackView.alignment = .center
    }

    private func setupConstraints() {
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(32)
        }

        textStackView.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().offset(-Constants.horizontalPadding)
        }

        topSeparator.snp.makeConstraints {
                    $0.leading.trailing.equalToSuperview()
                    $0.top.equalToSuperview().offset(-8)
                    $0.height.equalTo(1)
                }

                overlayButton.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
            }
    
    private func setupActions() {
        overlayButton.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
    }
    
    @objc private func handleTap() {
        onTapped?()
    }

    func showSeparator(_ show: Bool) {
        topSeparator.isHidden = !show
    }

    func configure(with viewModel: LeagueHeaderViewModel) {
        currentViewModel = viewModel
        logoImageView.image = nil
        countryLabel.text = viewModel.countryName
        leagueNameLabel.text = viewModel.leagueName
    }

    func updateLogoIfStillRelevant(for viewModel: LeagueHeaderViewModel) {
        guard currentViewModel === viewModel else { return }
        logoImageView.image = viewModel.logoImage
    }
    

}
