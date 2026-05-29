import Foundation

final class TokenStore {
    static let shared = TokenStore()
    private init() {}

    private enum Keys {
        static let token = "auth_token"
        static let userName = "auth_user_name"
    }

    var token: String? {
        get { KeychainStore.string(for: Keys.token) }
        set { KeychainStore.set(newValue, for: Keys.token) }
    }

    var userName: String? {
        get { KeychainStore.string(for: Keys.userName) }
        set { KeychainStore.set(newValue, for: Keys.userName) }
    }

    var isLoggedIn: Bool { token != nil }

    func save(_ response: LoginResponse) {
        token = response.token
        userName = response.name
    }

    func clear() {
        KeychainStore.delete(Keys.token)
        KeychainStore.delete(Keys.userName)
    }
}
