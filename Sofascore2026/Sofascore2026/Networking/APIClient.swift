import Foundation

nonisolated final class APIClient: Sendable {

    static let shared = APIClient()

    private init() {}

    enum APIError: Error {
        case invalidURL
        case networkError(Error)
        case decodingFailed(Error)
        case httpError(statusCode: Int)
    }


    func fetchEvents(for sportSlug: String) async throws -> [Event] {
        try await get(path: "/events", queryItems: [URLQueryItem(name: "sport", value: sportSlug)])
    }

    func fetchIncidents(eventId: Int) async throws -> [Incident] {
        try await get(path: "/events/\(eventId)/incidents")
    }

    func fetchLeagueMatches(leagueId: Int) async throws -> [Event] {
        try await get(path: "/leagues/\(leagueId)/matches")
    }

    func fetchStandings(leagueId: Int) async throws -> [LeagueStanding] {
        try await get(path: "/leagues/\(leagueId)/standings")
    }

    func fetchTeamDetails(teamId: Int) async throws -> TeamDetails {
        try await get(path: "/teams/\(teamId)")
    }

    func fetchTeamPlayers(teamId: Int) async throws -> [Player] {
        try await get(path: "/teams/\(teamId)/players")
    }

    func fetchTeamTournaments(teamId: Int) async throws -> [Tournament] {
        try await get(path: "/teams/\(teamId)/tournaments")
    }

    func login(username: String, password: String) async throws -> LoginResponse {
        guard let url = makeURL(path: "/login") else { throw APIError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(
                    LoginRequest(username: username, password: password)
                )
        return try await perform(request)
    }

    // MARK: - Helpers

    private func get<T: Decodable>(path: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        guard let url = makeURL(path: path, queryItems: queryItems) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        if let token = TokenStore.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return try await perform(request)
    }

    private func perform<T: Decodable>(_ request: URLRequest) async throws -> T {
        let data: Data
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, !(200..<300).contains(http.statusCode) {
                throw APIError.httpError(statusCode: http.statusCode)
            }
            data = responseData
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }

        do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    throw APIError.decodingFailed(error)
                }
    }

    private func makeURL(path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents(string: "https://sofascore-ios-academy-be-c63faa1a2212.herokuapp.com")
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }
}
