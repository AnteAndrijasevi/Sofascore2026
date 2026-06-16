import SwiftUI

struct IncidentRowView: View {
    let incident: Incident
    let displayScore: String?
    let sport: Sport

    private var iconName: String? {
        IncidentIconMapper.iconName(for: incident, sport: sport)
    }

    private var isHome: Bool {
        incident.isHomeTeam ?? true
    }

    var body: some View {
            HStack(alignment: .center, spacing: 8) {
                if isHome {
                    iconColumn
                    Divider()
                        .frame(height: 32)
                    contentColumn
                } else {
                    contentColumn
                    Divider()
                        .frame(height: 32)
                    iconColumn
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity)
        }

    private var iconColumn: some View {
        VStack(alignment: .center, spacing: 2) {
            iconView
            Text(minuteText)
                .font(AppFonts.captionSwiftUI)
                .foregroundColor(Color(AppColors.secondaryText))
        }
        .frame(width: 32)
    }

    @ViewBuilder
    private var iconView: some View {
        if let iconName {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)
        } else {
            Color.clear.frame(width: 16, height: 16)
        }
    }

    private var contentColumn: some View {
        VStack(alignment: isHome ? .leading : .trailing, spacing: 2) {
            HStack(spacing: 8) {
                if let score = displayScore {
                    Text(score)
                        .font(AppFonts.headlineSwiftUI)
                        .foregroundColor(Color(AppColors.primaryText))
                }
                if let player = incident.player {
                    Text(player)
                        .font(AppFonts.bodySwiftUI)
                        .foregroundColor(Color(AppColors.primaryText))
                }
            }
            if let secondaryLabel {
                Text(secondaryLabel)
                    .font(AppFonts.captionSwiftUI)
                    .foregroundColor(Color(AppColors.secondaryText))
            }
        }
        .frame(maxWidth: .infinity, alignment: isHome ? .leading : .trailing)
    }

    private var minuteText: String {
        if let extra = incident.extraMinute, extra > 0 {
            return "\(incident.minute)+\(extra)'"
        }
        return "\(incident.minute)'"
    }

    private var secondaryLabel: String? {
        switch incident.type {
                case .goal:
                    return incident.detail
                case .foul:
                    return AppStrings.foul
                case .yellowCard, .redCard:
                    return incident.detail        
                case .periodEnd, .unknown:
                    return nil
                }
    }
}

