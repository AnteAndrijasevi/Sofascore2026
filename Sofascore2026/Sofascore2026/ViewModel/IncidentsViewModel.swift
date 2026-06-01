import Foundation
import Combine

@MainActor
final class IncidentsViewModel: ObservableObject {

    enum State {
        case loading
        case loaded([IncidentSection])
        case empty
        case error
    }

    @Published private(set) var state: State = .loading

    private let eventId: Int
    private let sport: Sport
    private var loadTask: Task<Void, Never>?

    init(eventId: Int, sport: Sport) {
        self.eventId = eventId
        self.sport = sport
    }

    func load() {
        loadTask?.cancel()
        loadTask = Task { [weak self] in
            guard let self else { return }
            state = .loading
            do {
                let incidents = try await APIClient.shared.fetchIncidents(eventId: eventId)
                try Task.checkCancellation()

                if incidents.isEmpty {
                    state = .empty
                } else {
                    let displayable = computeDisplayScores(for: incidents, sport: sport)
                    let sections = IncidentsGrouper.sections(from: displayable, sport: sport)
                    state = .loaded(sections)
                }
            } catch is CancellationError {
                return
            } catch {
                state = .error
            }
        }
    }

    private func computeDisplayScores(for incidents: [Incident], sport: Sport) -> [DisplayableIncident] {
        var home = 0
        var away = 0

        return incidents.map { incident in
            if incident.type == .goal, let diff = incident.scoreDiff {
                if incident.isHomeTeam == true {
                    home += diff
                } else if incident.isHomeTeam == false {
                    away += diff
                }
            }
            let displayScore = displayScore(for: incident, home: home, away: away, sport: sport)
            return DisplayableIncident(incident: incident, displayScore: displayScore)
        }
    }

    private func displayScore(for incident: Incident, home: Int, away: Int, sport: Sport) -> String? {
        guard incident.type == .goal else { return nil }
        if let score = incident.score {
            return score
        }
        if sport == .basketball {
            return "\(home) - \(away)"
        }
        return nil
    }
}
