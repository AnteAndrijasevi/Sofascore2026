import UIKit
import SnapKit

final class PlayerCell: UITableViewCell {

    static let identifier = "PlayerCell"

    private enum Constants {
            static let avatarSize: CGFloat = 32
            static let horizontalPadding: CGFloat = 16
        }

    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let countryLabel = UILabel()
    private let textStack = UIStackView()

    private var currentViewModel: PlayerCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        contentView.addSubview(avatarImageView)
        contentView.addSubview(textStack)
        textStack.addArrangedSubview(nameLabel)
        textStack.addArrangedSubview(countryLabel)
    }

    private func styleViews() {
        selectionStyle = .none
        backgroundColor = AppColors.surface

        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.backgroundColor = AppColors.roundSectionBackground
        avatarImageView.layer.cornerRadius = Constants.avatarSize / 2
        avatarImageView.clipsToBounds = true

        nameLabel.font = AppFonts.body
        nameLabel.textColor = AppColors.primaryText

        countryLabel.font = AppFonts.caption
        countryLabel.textColor = AppColors.secondaryText

        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.alignment = .leading
    }

    private func setupConstraints() {
        avatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constants.horizontalPadding)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(Constants.avatarSize)
        }

        textStack.snp.makeConstraints {
            $0.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().inset(Constants.horizontalPadding)
        }
    }

    func configure(with viewModel: PlayerCellViewModel) {
            currentViewModel = viewModel
            nameLabel.text = viewModel.name
            countryLabel.text = viewModel.countryName
            avatarImageView.image = nil
        }

        func updateAvatarIfStillRelevant(for viewModel: PlayerCellViewModel) {
            guard currentViewModel === viewModel else { return }
            avatarImageView.image = viewModel.avatar
        }
}
