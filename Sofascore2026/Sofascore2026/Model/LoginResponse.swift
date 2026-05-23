import Foundation

struct LoginResponse: Decodable, Sendable {
    let name: String
    let token: String
}
