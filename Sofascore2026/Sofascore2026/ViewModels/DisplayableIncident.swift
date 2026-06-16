import Foundation

struct DisplayableIncident: Identifiable {
    let id: Int
    let incident: Incident
    let displayScore: String?
}
