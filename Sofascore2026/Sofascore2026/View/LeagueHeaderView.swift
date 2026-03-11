//
//  LeagueHeaderView.swift
//  Sofascore2026
//
//  Created by Ante Andrijašević on 10/03/2026.
//
import UIKit
import SnapKit

final class LeagueHeaderView: UIView {

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

    private let arrowImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "ic_pointer_right")
        iv.contentMode = .scaleAspectFit
        return iv
    }()

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
        backgroundColor = AppColors.surface

        textStackView.addArrangedSubview(countryLabel)
        textStackView.addArrangedSubview(arrowImageView)

        textStackView.addArrangedSubview(leagueNameLabel)

        addSubview(logoImageView)
        addSubview(textStackView)

        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(32)
        }

        textStackView.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }

    func configure(with viewModel: LeagueHeaderViewModel) {
        countryLabel.text = viewModel.countryName
        leagueNameLabel.text = viewModel.leagueName

        if let urlString = viewModel.logoUrl, let url = URL(string: urlString) {
            loadImage(from: url)
        }
    }

    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self?.logoImageView.image = image
            }
        }.resume()
    }
}
