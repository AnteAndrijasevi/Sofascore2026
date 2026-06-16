import UIKit
import SnapKit

final class TeamDetailsView: UIView {

    private enum Constants {
        static let horizontalPadding: CGFloat = 16
        static let sectionSpacing: CGFloat = 24
        static let managerAvatarSize: CGFloat = 32
    }

    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()

    private let teamInfoTitleLabel = UILabel()
    private let coachContainer = UIView()
    private let coachAvatarImageView = UIImageView()
    private let coachLabel = UILabel()
    private let coachCountryLabel = UILabel()
    private let coachTextStack = UIStackView()

    private let playersCountLabel = UILabel()
    private let playersCountCaptionLabel = UILabel()
    private let playersCountStack = UIStackView()

    private let tournamentsTitleLabel = UILabel()
    private let tournamentsGrid = UIStackView()

    private let venueTitleLabel = UILabel()
    private let venueValueLabel = UILabel()
    private let venueRowStack = UIStackView()

    private let errorView = EmptyStateView()
    
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
        addSubview(scrollView)
        addSubview(errorView)
        scrollView.addSubview(contentStack)

        contentStack.addArrangedSubview(teamInfoTitleLabel)
        contentStack.addArrangedSubview(coachContainer)
        contentStack.addArrangedSubview(playersCountStack)
        contentStack.addArrangedSubview(tournamentsTitleLabel)
        contentStack.addArrangedSubview(tournamentsGrid)
        contentStack.addArrangedSubview(venueTitleLabel)
        contentStack.addArrangedSubview(venueRowStack)

        coachContainer.addSubview(coachAvatarImageView)
        coachContainer.addSubview(coachTextStack)
        coachTextStack.addArrangedSubview(coachLabel)
        coachTextStack.addArrangedSubview(coachCountryLabel)

        playersCountStack.addArrangedSubview(playersCountLabel)
        playersCountStack.addArrangedSubview(playersCountCaptionLabel)

        venueRowStack.addArrangedSubview(makeStaticLabel(text: AppStrings.stadium))
        venueRowStack.addArrangedSubview(UIView())
        venueRowStack.addArrangedSubview(venueValueLabel)
    }

    private func styleViews() {
        backgroundColor = AppColors.surface

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.alignment = .fill
        contentStack.isLayoutMarginsRelativeArrangement = true
        contentStack.layoutMargins = UIEdgeInsets(top: 16, left: Constants.horizontalPadding, bottom: 16, right: Constants.horizontalPadding)

        teamInfoTitleLabel.text = AppStrings.teamInfo
        teamInfoTitleLabel.font = AppFonts.headline
        teamInfoTitleLabel.textColor = AppColors.primaryText
        teamInfoTitleLabel.textAlignment = .center

        coachAvatarImageView.contentMode = .scaleAspectFit
        coachAvatarImageView.backgroundColor = AppColors.roundSectionBackground
        coachAvatarImageView.layer.cornerRadius = Constants.managerAvatarSize / 2
        coachAvatarImageView.clipsToBounds = true

        coachLabel.font = AppFonts.body
        coachLabel.textColor = AppColors.primaryText

        coachCountryLabel.font = AppFonts.caption
        coachCountryLabel.textColor = AppColors.secondaryText

        coachTextStack.axis = .vertical
        coachTextStack.spacing = 2
        coachTextStack.alignment = .leading

        playersCountLabel.font = AppFonts.scoreboard
        playersCountLabel.textColor = AppColors.primary
        playersCountLabel.textAlignment = .center

        playersCountCaptionLabel.text = AppStrings.totalPlayers
        playersCountCaptionLabel.font = AppFonts.caption
        playersCountCaptionLabel.textColor = AppColors.secondaryText
        playersCountCaptionLabel.textAlignment = .center

        playersCountStack.axis = .vertical
        playersCountStack.spacing = 4
        playersCountStack.alignment = .center

        tournamentsTitleLabel.text = AppStrings.tournaments
        tournamentsTitleLabel.font = AppFonts.headline
        tournamentsTitleLabel.textColor = AppColors.primaryText
        tournamentsTitleLabel.textAlignment = .center

        tournamentsGrid.axis = .vertical
        tournamentsGrid.spacing = 16
        tournamentsGrid.alignment = .fill

        venueTitleLabel.text = AppStrings.venue
        venueTitleLabel.font = AppFonts.headline
        venueTitleLabel.textColor = AppColors.primaryText
        venueTitleLabel.textAlignment = .center

        venueValueLabel.font = AppFonts.body
        venueValueLabel.textColor = AppColors.primaryText

        venueRowStack.axis = .horizontal
        venueRowStack.alignment = .center

        contentStack.setCustomSpacing(Constants.sectionSpacing, after: coachContainer)
        contentStack.setCustomSpacing(Constants.sectionSpacing, after: playersCountStack)
        contentStack.setCustomSpacing(Constants.sectionSpacing, after: tournamentsGrid)
    }

    private func setupConstraints() {
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentStack.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
        }

        coachAvatarImageView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.size.equalTo(Constants.managerAvatarSize)
        }

        coachTextStack.snp.makeConstraints {
            $0.leading.equalTo(coachAvatarImageView.snp.trailing).offset(12)
            $0.centerY.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
    }

    private func makeStaticLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = AppFonts.body
        label.textColor = AppColors.secondaryText
        return label
    }

    func update(
            coachName: String?,
            coachCountry: String?,
            coachImage: UIImage?,
            playersCount: Int,
            tournaments: [Tournament],
            tournamentLogos: [Int: UIImage],
            venueName: String?
        ) {
            errorView.hide()
            
            coachLabel.text = AppStrings.coachPrefix + (coachName ?? "-")
            coachCountryLabel.text = coachCountry
            coachContainer.isHidden = coachName == nil
            coachAvatarImageView.image = coachImage

            playersCountLabel.text = "\(playersCount)"

            renderTournaments(tournaments, logos: tournamentLogos)

            venueValueLabel.text = venueName ?? "-"
        }

    private func renderTournaments(_ tournaments: [Tournament], logos: [Int: UIImage]) {
        tournamentsGrid.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let columnsPerRow = 3
        var currentRow: UIStackView?

        for (index, tournament) in tournaments.enumerated() {
            if index % columnsPerRow == 0 {
                let row = UIStackView()
                row.axis = .horizontal
                row.spacing = 16
                row.distribution = .fillEqually
                tournamentsGrid.addArrangedSubview(row)
                currentRow = row
            }
            currentRow?.addArrangedSubview(makeTournamentItemView(for: tournament, logo: logos[tournament.id]))
        }

        if let lastRow = currentRow {
            let remaining = columnsPerRow - (tournaments.count % columnsPerRow)
            if remaining > 0 && remaining < columnsPerRow {
                for _ in 0..<remaining {
                    lastRow.addArrangedSubview(UIView())
                }
            }
        }
    }

    private func makeTournamentItemView(for tournament: Tournament, logo: UIImage?) -> UIView {
        let container = UIStackView()
        container.axis = .vertical
        container.spacing = 4
        container.alignment = .center

        let logoView = UIImageView()
        logoView.contentMode = .scaleAspectFit
        logoView.snp.makeConstraints {
            $0.size.equalTo(40)
        }

        let nameLabel = UILabel()
        nameLabel.text = tournament.name
        nameLabel.font = AppFonts.caption
        nameLabel.textColor = AppColors.primaryText
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.8

        logoView.image = logo

        container.addArrangedSubview(logoView)
        container.addArrangedSubview(nameLabel)

                return container
    }
    
    func showError() {
        errorView.show()
    }
}
