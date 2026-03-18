import UIKit
import SnapKit

final class SportSelectorView: UIView {

    var onSportSelected: ((Sport) -> Void)?
    private var selectedSport: Sport = .football
    private let sports: [Sport] = [.football, .basketball, .americanFootball]
    private var itemViews: [SportSelectorItemView] = []

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
        populateItems()
    }

    private func styleViews() {
        backgroundColor = AppColors.primary

        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
    }

    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func populateItems() {
        for sport in sports {
            let itemView = SportSelectorItemView()
            itemView.configure(with: sport, isSelected: sport == selectedSport)
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            itemView.addGestureRecognizer(tap)
            itemViews.append(itemView)
            stackView.addArrangedSubview(itemView)
        }
    }

    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        guard let tappedView = gesture.view as? SportSelectorItemView,
              let index = itemViews.firstIndex(where: { $0 === tappedView }) else { return }
        let sport = sports[index]
        guard sport != selectedSport else { return }
        selectedSport = sport
        updateSelection()
        onSportSelected?(sport)
    }

    private func updateSelection() {
        for (index, itemView) in itemViews.enumerated() {
            itemView.configure(with: sports[index], isSelected: sports[index] == selectedSport)
        }
    }
}
