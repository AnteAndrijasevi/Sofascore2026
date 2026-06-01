import Foundation

enum IncidentsGrouper {

    static func sections(from incidents: [DisplayableIncident], sport: Sport) -> [IncidentSection] {
        var sections: [IncidentSection] = []
        var currentBucket: [DisplayableIncident] = []

        for displayable in incidents {
            if displayable.incident.type == .periodEnd {
                let header = makeHeader(
                    forCompletedPeriodAt: sections.count,
                    marker: displayable.incident,
                    sport: sport
                )
                sections.append(IncidentSection(header: header, incidents: currentBucket))
                currentBucket = []
            } else {
                currentBucket.append(displayable)
            }
        }

        if !currentBucket.isEmpty {
            let header = makeHeader(
                forOngoingPeriodAt: sections.count,
                sport: sport
            )
            sections.append(IncidentSection(header: header, incidents: currentBucket))
        }

        return sections
    
    }

    private static func makeHeader(
        forCompletedPeriodAt index: Int,
        marker: Incident,
        sport: Sport
    ) -> String {
        switch sport {
        case .football:
            return footballHeader(periodIndex: index, marker: marker)
        case .basketball:
            return marker.description ?? "Q\(index + 1)"
        case .americanFootball:
            return americanFootballHeader(periodIndex: index, marker: marker)
        }
    }

    private static func makeHeader(forOngoingPeriodAt index: Int, sport: Sport) -> String {
        switch sport {
        case .football:
            return index == 0 ? "First Half" : "Second Half"
        case .basketball, .americanFootball:
            return "Q\(index + 1)"
        }
    }

    private static func footballHeader(periodIndex: Int, marker: Incident) -> String {
        let baseName = periodIndex == 0 ? "First Half" : "Second Half"
        guard let score = marker.score else { return baseName }
        switch marker.description {
        case "HT": return "HT (\(score))"
        case "FT": return "FT (\(score))"
        default:   return "\(baseName) (\(score))"
        }
    }

    private static func americanFootballHeader(periodIndex: Int, marker: Incident) -> String {
        let quarter = marker.description ?? "Q\(periodIndex + 1)"
        guard let score = marker.score else { return quarter }
        return "\(quarter) (\(score))"
    }
}
