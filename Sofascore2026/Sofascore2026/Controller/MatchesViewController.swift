import UIKit
import SnapKit
import SofaAcademic

final class MatchesViewController: UIViewController {

    private enum Constants {
        static let headerHeight: CGFloat = 56
        static let rowHeight: CGFloat = 56
    }

    private let dataSource = Homework2DataSource()
    private let scrollView = UIScrollView()
    private let contentStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 0
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        populateData()
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
    }

    private func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
    }

    private func styleViews() {
        view.backgroundColor = AppColors.surface
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }

        contentStack.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView)
        }
    }

    private func populateData() {
        let league = dataSource.laLigaLeague()
        let events = dataSource.laLigaEvents()

        let headerViewModel = LeagueHeaderViewModel(league: league)
        let headerView = LeagueHeaderView()
        headerView.snp.makeConstraints { $0.height.equalTo(Constants.headerHeight) }
        contentStack.addArrangedSubview(headerView)

        headerViewModel.fetchImage {
            headerView.configure(with: headerViewModel)
        }

        for event in events {
            let rowViewModel = MatchRowViewModel(event: event)
            let rowView = MatchRowView()
            rowView.snp.makeConstraints { $0.height.equalTo(Constants.rowHeight) }
            contentStack.addArrangedSubview(rowView)

            rowViewModel.fetchImages {
                rowView.configure(with: rowViewModel)
            }
        }
    }
}
