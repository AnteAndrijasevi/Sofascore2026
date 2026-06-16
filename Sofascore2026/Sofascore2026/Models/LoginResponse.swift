import Foundation

nonisolated struct LoginResponse: Decodable, Sendable {
    let name: String
    let token: String
}
