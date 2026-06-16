import Foundation

struct IncidentSection: Identifiable {
    let id: Int
    let header: String
    let incidents: [DisplayableIncident]
}
