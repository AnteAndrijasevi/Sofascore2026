import Foundation

struct DisplayableIncident: Identifiable {
    let incident: Incident
    let displayScore: String?

    var id: String { incident.id }
}
