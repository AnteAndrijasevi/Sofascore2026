import Foundation
@preconcurrency import Alamofire

final class APIClient {

    static let shared = APIClient()

    private init() {}

    private static let decoder = JSONDecoder()

    private enum Constants {
        static let baseURL = "https://sofascore-ios-academy-be-c63faa1a2212.herokuapp.com"
    }

    enum APIError: Error {
        case invalidURL
        case networkError(Error)
        case decodingFailed
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

        let data: Data
        do {
            let (responseData, _) = try await URLSession.shared.data(from: url)
            data = responseData
        } catch {
            throw APIError.networkError(error)
        }

        guard let events = try? Self.decoder.decode([Event].self, from: data) else {
            throw APIError.decodingFailed
        }

        return events
    }

    func fetchEventsWithAlamofire(for sportSlug: String) async throws -> [Event] {
        guard let url = makeEventsURL(sportSlug: sportSlug) else {
            throw APIError.invalidURL
        }

        let response = await AF.request(url)
            .serializingDecodable([Event].self)
            .response

        switch response.result {
        case .success(let events):
            return events
        case .failure(let afError):
            if afError.isResponseSerializationError {
                throw APIError.decodingFailed
            } else {
                throw APIError.networkError(afError)
            }
        }
    }
}
