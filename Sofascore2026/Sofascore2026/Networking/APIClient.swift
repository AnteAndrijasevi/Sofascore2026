import Foundation

final class APIClient {

    static let shared = APIClient()

    private init() {}

    private static let decoder = JSONDecoder()
    private static let encoder = JSONEncoder()

    private enum Constants {
        static let baseURL = "https://sofascore-ios-academy-be-c63faa1a2212.herokuapp.com"
    }

    enum APIError: Error {
        case invalidURL
        case networkError(Error)
        case decodingFailed(Error)
        case httpError(statusCode: Int)
    }

    private func makeEventsURL(sportSlug: String) -> URL? {
        var components = URLComponents(string: Constants.baseURL)
        components?.path = "/events"
        components?.queryItems = [URLQueryItem(name: "sport", value: sportSlug)]
        return components?.url
    }

    func fetchEvents(for sportSlug: String) async throws -> [Event] {
        guard let url = makeEventsURL(sportSlug: sportSlug) else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        if let token = TokenStore.shared.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let data: Data
        do {
            let (responseData, response) = try await URLSession.shared.data(for: request)
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            data = responseData
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
        do {
            return try Self.decoder.decode([Event].self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }

    private func makeURL(path: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        var components = URLComponents(string: Constants.baseURL)
        components?.path = path
        components?.queryItems = queryItems
        return components?.url
    }

    func login(username: String, password: String) async throws -> LoginResponse {
        guard let url = makeURL(path: "/login") else {
            throw APIError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try Self.encoder.encode(
            LoginRequest(username: username, password: password)
        )

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
            return try Self.decoder.decode(LoginResponse.self, from: data)
        } catch {
            throw APIError.decodingFailed(error)
        }
    }
    
    
}
