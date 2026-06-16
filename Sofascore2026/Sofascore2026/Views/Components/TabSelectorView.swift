import UIKit
import SnapKit

enum TabIndex: Int, CaseIterable {
    case first
    case second
}

final class TabSelectorView: UIView {
    
    private enum Constants {
        static let indicatorHeight: CGFloat = 3
    }
    
    private let onTabSelected: (TabIndex) -> Void
    private var selectedTab: TabIndex = .first
    
    private let stackView = UIStackView()
    private let indicator = UIView()
    private var buttons: [UIButton] = []
    private var indicatorLeading: Constraint?
    private var indicatorWidth: Constraint?
    
    init(titles: [String], onTabSelected: @escaping (TabIndex) -> Void) {
        precondition(titles.count == TabIndex.allCases.count, "Must provide exactly \(TabIndex.allCases.count) titles")
        self.onTabSelected = onTabSelected
        super.init(frame: .zero)
        setupUI(titles: titles)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(titles: [String]) {
        addViews(titles: titles)
        styleViews()
        setupConstraints()
        setupActions()
        updateIndicatorPosition(animated: false)
    }
    
    private func addViews(titles: [String]) {
        addSubview(stackView)
        addSubview(indicator)
        
        for (index, title) in titles.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.tag = index
            buttons.append(button)
            stackView.addArrangedSubview(button)
        }
    }
    
    private func styleViews() {
        backgroundColor = AppColors.primary
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        
        indicator.backgroundColor = AppColors.onPrimary
        indicator.layer.cornerRadius = Constants.indicatorHeight / 2
        
        for button in buttons {
            button.titleLabel?.font = AppFonts.headline
            button.setTitleColor(AppColors.onPrimary, for: .normal)
        }
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(12 + Constants.indicatorHeight)
        }
        
        indicator.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(Constants.indicatorHeight)
            indicatorLeading = $0.leading.equalToSuperview().constraint
            indicatorWidth = $0.width.equalTo(0).constraint
        }
    }
    
    private func setupActions() {
        for button in buttons {
            button.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        }
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
            guard let tab = TabIndex(rawValue: sender.tag),
                  tab != selectedTab else { return }
            selectedTab = tab
            updateIndicatorPosition(animated: true)
            onTabSelected(tab)
        }

    override func layoutSubviews() {
            super.layoutSubviews()
            updateIndicatorPosition(animated: false)
        }

    private func updateIndicatorPosition(animated: Bool) {
        let tabWidth = bounds.width / CGFloat(TabIndex.allCases.count)
        let offset = tabWidth * CGFloat(selectedTab.rawValue)

        indicatorLeading?.update(offset: offset)
        indicatorWidth?.update(offset: tabWidth)

        guard animated else { return }
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}

