import Foundation

enum IncidentIconMapper {

    static func iconName(for incident: Incident, sport: Sport) -> String? {
        switch incident.type {
        case .goal:
            return goalIcon(scoreDiff: incident.scoreDiff, sport: sport)
        case .yellowCard:
            return "ic_incident_yellow_card"
        case .redCard:
            return "ic_incident_red_card"
        case .foul, .periodEnd, .unknown:
            return nil
        }
    }

    private static func goalIcon(scoreDiff: Int?, sport: Sport) -> String? {
        switch sport {
        case .football:
            return "ic_incident_goal_football"
        case .basketball:
            switch scoreDiff {
            case 1: return "ic_incident_basketball_1"
            case 2: return "ic_incident_basketball_2"
            case 3: return "ic_incident_basketball_3"
            default: return "ic_incident_basketball_1"
            }
        case .americanFootball:
            switch scoreDiff {
            case 3: return "ic_incident_amf_field_goal"
            case 6: return "ic_incident_amf_touchdown"
            case 7: return "ic_incident_amf_extra_point"
            case 8: return "ic_incident_amf_two_point"
            default: return "ic_incident_amf_field_goal"
            }
        }
    }
}
