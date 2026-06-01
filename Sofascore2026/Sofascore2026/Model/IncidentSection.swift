import Foundation

struct IncidentSection: Identifiable {
    let id = UUID()
    let header: String
    let incidents: [DisplayableIncident]
}
