import Foundation

enum IncidentIconMapper {

    static func iconName(for incident: Incident, sport: Sport) -> String? {
        switch incident.type {
        case .goal:
            return goalIcon(scoreDiff: incident.scoreDiff, sport: sport)
        case .yellowCard:
            return AppStrings.icIncidentYellowCard
        case .redCard:
            return AppStrings.icIncidentRedCard
        case .foul, .periodEnd, .unknown:
            return nil
        }
    }

    private static func goalIcon(scoreDiff: Int?, sport: Sport) -> String? {
        switch sport {
        case .football:
            return AppStrings.icIncidentGoalFootball
        case .basketball:
            switch scoreDiff {
            case 1: return AppStrings.icIncidentBasketball1
            case 2: return AppStrings.icIncidentBasketball2
            case 3: return AppStrings.icIncidentBasketball3
            default: return AppStrings.icIncidentBasketball1
            }
        case .americanFootball:
            switch scoreDiff {
            case 3: return AppStrings.icIncidentAmfFieldGoal
            case 6: return AppStrings.icIncidentAmfTouchdown
            case 7: return AppStrings.icIncidentAmfExtraPoint
            case 8: return AppStrings.icIncidentAmfTwoPoint
            default: return AppStrings.icIncidentAmfFieldGoal
            }
        }
    }
}
