import Foundation

struct LoginViewModel {
    func login(username: String, password: String) async throws {
        let response = try await APIClient.shared.login(username: username, password: password)
        TokenStore.shared.save(response)
    }
}
