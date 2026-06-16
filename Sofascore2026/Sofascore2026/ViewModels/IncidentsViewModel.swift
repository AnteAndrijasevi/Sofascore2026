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
    
    func loadIfNeeded() {
        if loadTask == nil {
            load()
            return
        }
        if case .error = state {
            load()
        }
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
                    state = .loaded(Self.reversedForDisplay(sections))
                }
            } catch is CancellationError {
                return
            } catch {
                guard !Task.isCancelled else { return }
                state = .error
            }
        }
    }
    
    private func computeDisplayScores(for incidents: [Incident], sport: Sport) -> [DisplayableIncident] {
        var home = 0
        var away = 0
        
        return incidents.enumerated().map { index, incident in
            if incident.type == .goal, let diff = incident.scoreDiff {
                if incident.isHomeTeam == true {
                    home += diff
                } else if incident.isHomeTeam == false {
                    away += diff
                }
            }
            let displayScore = displayScore(for: incident, home: home, away: away, sport: sport)
            return DisplayableIncident(id: index, incident: incident, displayScore: displayScore)
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
    
    private static func reversedForDisplay(_ sections: [IncidentSection]) -> [IncidentSection] {
        sections.reversed().map {
            IncidentSection(id: $0.id, header: $0.header, incidents: $0.incidents.reversed())
        }
    }
}
