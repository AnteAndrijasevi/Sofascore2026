import UIKit
import SnapKit

final class MatchRowCell: UITableViewCell {

    static let identifier = "MatchRowCell"

    private let matchRowView = MatchRowView()
    private var currentViewModel: MatchRowViewModel?

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
        contentView.addSubview(matchRowView)
    }

    private func styleViews() {
        selectionStyle = .none
        backgroundColor = AppColors.surface
    }

    private func setupConstraints() {
        matchRowView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func configure(with viewModel: MatchRowViewModel) {
        currentViewModel = viewModel
        matchRowView.configure(with: viewModel)
    }

    func updateImagesIfStillRelevant(for viewModel: MatchRowViewModel) {
        guard currentViewModel === viewModel else { return }
        matchRowView.updateImages(with: viewModel)
    }
}
