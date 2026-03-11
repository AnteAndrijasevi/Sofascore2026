//
//  MatchRowView.swift
//  Sofascore2026
//
//  Created by Ante Andrijašević on 10/03/2026.
//

import UIKit
import SnapKit

final class MatchRowView: UIView {

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = AppFonts.caption
        label.textColor = AppColors.secondaryText
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()

    private let timeStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 2
        sv.alignment = .center
        sv.distribution = .fillEqually
        return sv
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.secondaryText.withAlphaComponent(0.3)
        return view
    }()

    private let homeLogoImageView = MatchRowView.makeTeamLogo()
    private let awayLogoImageView = MatchRowView.makeTeamLogo()

    private let homeNameLabel = MatchRowView.makeTeamNameLabel()
    private let awayNameLabel = MatchRowView.makeTeamNameLabel()

    private let homeScoreLabel = MatchRowView.makeScoreLabel()
    private let awayScoreLabel = MatchRowView.makeScoreLabel()

    private let homeRowStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()

    private let awayRowStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 8
        sv.alignment = .center
        return sv
    }()

    private let teamsStackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 4
        sv.distribution = .fillEqually
        return sv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private static func makeTeamLogo() -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }

    private static func makeTeamNameLabel() -> UILabel {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColors.primaryText
        label.numberOfLines = 1
        return label
    }

    private static func makeScoreLabel() -> UILabel {
        let label = UILabel()
        label.font = AppFonts.body
        label.textColor = AppColors.primaryText
        label.textAlignment = .right
        label.numberOfLines = 1
        return label
    }

    private func setupUI() {
        backgroundColor = AppColors.surface

        timeStackView.addArrangedSubview(timeLabel)
        timeStackView.addArrangedSubview(statusLabel)

        homeRowStack.addArrangedSubview(homeLogoImageView)
        homeRowStack.addArrangedSubview(homeNameLabel)
        homeRowStack.addArrangedSubview(homeScoreLabel)

        awayRowStack.addArrangedSubview(awayLogoImageView)
        awayRowStack.addArrangedSubview(awayNameLabel)
        awayRowStack.addArrangedSubview(awayScoreLabel)

        teamsStackView.addArrangedSubview(homeRowStack)
        teamsStackView.addArrangedSubview(awayRowStack)

        addSubview(timeStackView)
        addSubview(separator)
        addSubview(teamsStackView)

        timeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(40)
        }

        separator.snp.makeConstraints {
            $0.leading.equalTo(timeStackView.snp.trailing).offset(8)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(1)
            $0.height.equalTo(40)
        }

        teamsStackView.snp.makeConstraints {
            $0.leading.equalTo(separator.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().offset(-8)
            $0.centerY.equalToSuperview()
        }

        homeLogoImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }

        awayLogoImageView.snp.makeConstraints {
            $0.width.height.equalTo(16)
        }

        homeScoreLabel.snp.makeConstraints {
            $0.width.equalTo(20)
        }

        awayScoreLabel.snp.makeConstraints {
            $0.width.equalTo(20)
        }
    }

    func configure(with viewModel: MatchRowViewModel) {
        timeLabel.text = viewModel.timeOrStatus
        statusLabel.text = viewModel.statusLine

        if viewModel.isLive {
            statusLabel.textColor = AppColors.liveRed
        } else {
            statusLabel.textColor = AppColors.secondaryText
        }

        homeNameLabel.text = viewModel.homeTeamName
        awayNameLabel.text = viewModel.awayTeamName

        homeScoreLabel.text = viewModel.homeScore
        awayScoreLabel.text = viewModel.awayScore

        if let homeWon = viewModel.homeWon {
            homeNameLabel.textColor = homeWon ? AppColors.primaryText : AppColors.secondaryText
            homeScoreLabel.textColor = homeWon ? AppColors.primaryText : AppColors.secondaryText
            awayNameLabel.textColor = homeWon ? AppColors.secondaryText : AppColors.primaryText
            awayScoreLabel.textColor = homeWon ? AppColors.secondaryText : AppColors.primaryText
        }

        loadImage(from: viewModel.homeTeamLogoUrl, into: homeLogoImageView)
        loadImage(from: viewModel.awayTeamLogoUrl, into: awayLogoImageView)
    }

    private func loadImage(from urlString: String?, into imageView: UIImageView) {
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { [weak imageView] data, _, _ in
            guard let data = data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView?.image = image
            }
        }.resume()
    }
}
