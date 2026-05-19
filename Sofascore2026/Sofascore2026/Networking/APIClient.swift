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
        case httpError(statusCode: Int)
    }

    private func makeEventsURL(sportSlug: String) -> URL? {
        var components = URLComponents(string: Constants.baseURL)
        components?.path = "/events"
        components?.queryItems = [URLQueryItem(name: "sport", value: sportSlug)]
        return components?.url
    }

    func fetchEvents(
        for sportSlug: String,
        completion: @escaping (Result<[Event], APIError>) -> Void
    ) {
        guard let url = makeEventsURL(sportSlug: sportSlug) else {
            DispatchQueue.main.async { completion(.failure(.invalidURL)) }
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error {
                DispatchQueue.main.async { completion(.failure(.networkError(error))) }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                DispatchQueue.main.async { completion(.failure(.httpError(statusCode: httpResponse.statusCode))) }
                return
            }

            guard let data else {
                DispatchQueue.main.async { completion(.failure(.networkError(URLError(.badServerResponse)))) }
                return
            }

            do {
                let events = try Self.decoder.decode([Event].self, from: data)
                DispatchQueue.main.async { completion(.success(events)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingFailed)) }
            }
        }.resume()
    }

    func fetchEvents(for sportSlug: String) async throws -> [Event] {
        guard let url = makeEventsURL(sportSlug: sportSlug) else {
            throw APIError.invalidURL
        }

        let data: Data
        do {
            let (responseData, response) = try await URLSession.shared.data(from: url)
            if let httpResponse = response as? HTTPURLResponse, !(200..<300).contains(httpResponse.statusCode) {
                throw APIError.httpError(statusCode: httpResponse.statusCode)
            }
            data = responseData
        } catch let error as APIError {
            throw error
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
