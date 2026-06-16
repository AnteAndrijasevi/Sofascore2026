import UIKit
import SwiftUI
import SnapKit

final class TeamOfTheSeasonViewController: UIViewController {

    private var hostingController: UIHostingController<TeamOfTheSeasonView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    private func setupUI() {
        addViews()
        styleViews()
        setupConstraints()
    }

    private func addViews() {
        let rootView = TeamOfTheSeasonView(onClose: { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        })
        let hosting = UIHostingController(rootView: rootView)
        hostingController = hosting

        addChild(hosting)
        view.addSubview(hosting.view)
        hosting.didMove(toParent: self)
    }

    private func styleViews() {
        view.backgroundColor = AppColors.surface
        hostingController?.view.backgroundColor = AppColors.surface
    }

    private func setupConstraints() {
        hostingController?.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
