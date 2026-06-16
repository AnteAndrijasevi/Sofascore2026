import Foundation
import Security
import OSLog

nonisolated enum KeychainStore {
    private static let service = Bundle.main.bundleIdentifier ?? "com.sofascore.academy"

    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier ?? "Sofascore2026",
        category: "KeychainStore"
    )

    static func string(for key: String) -> String? {
        var query = baseQuery(for: key)
        query[kSecReturnData as String] = true
        query[kSecMatchLimit as String] = kSecMatchLimitOne

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            return nil
        }
        return value
    }

    @discardableResult
        static func set(_ value: String?, for key: String) -> Bool {
            guard let value, let data = value.data(using: .utf8) else {
                delete(key)
                return true
            }

            let attributes: [String: Any] = [
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
            ]

            let status = SecItemUpdate(baseQuery(for: key) as CFDictionary, attributes as CFDictionary)
            if status == errSecSuccess { return true }

            if status == errSecItemNotFound {
                var addQuery = baseQuery(for: key)
                addQuery[kSecValueData as String] = data
                addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
                let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
                if addStatus != errSecSuccess {
                    logger.error("SecItemAdd failed for key \(key): \(addStatus)")
                    return false
                }
                return true
            }

            logger.error("SecItemUpdate failed for key \(key): \(status)")
            return false
        }

            static func delete(_ key: String) {
                let status = SecItemDelete(baseQuery(for: key) as CFDictionary)
                if status != errSecSuccess && status != errSecItemNotFound {
                    logger.error("SecItemDelete failed for key \(key): \(status)")
                }
            }

    private static func baseQuery(for key: String) -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
    }
}
