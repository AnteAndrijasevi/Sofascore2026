//
//  MatchesViewController.swift
//  Sofascore2026
//
//  Created by Ante Andrijašević on 10/03/2026.
//

import UIKit
import SnapKit
import SofaAcademic

final class MatchesViewController: UIViewController {

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
        view.backgroundColor = AppColors.surface

        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)

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
        headerView.configure(with: headerViewModel)
        headerView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        contentStack.addArrangedSubview(headerView)


        for event in events {
            let rowViewModel = MatchRowViewModel(event: event)
            let rowView = MatchRowView()
            rowView.configure(with: rowViewModel)
            rowView.snp.makeConstraints {
                $0.height.equalTo(56)
            }
            contentStack.addArrangedSubview(rowView)
        


        }
    }


}
