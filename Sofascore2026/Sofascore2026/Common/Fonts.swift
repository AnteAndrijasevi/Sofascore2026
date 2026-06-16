import UIKit
import SwiftUI

enum AppFonts {
    static let headline = UIFont.systemFont(ofSize: 14, weight: .bold)
    static let body = UIFont.systemFont(ofSize: 14, weight: .regular)
    static let caption = UIFont.systemFont(ofSize: 12, weight: .regular)
    static let scoreboard = UIFont.systemFont(ofSize: 36, weight: .bold)
    static let subtitle = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let button = UIFont.systemFont(ofSize: 16, weight: .bold)
}

// MARK: - SwiftUI
extension AppFonts {
    static let bodySwiftUI = Font.system(size: 14)
    static let captionSwiftUI = Font.system(size: 12)
    static let headlineSwiftUI = Font.system(size: 14, weight: .bold)
    static let sectionHeaderSwiftUI = Font.system(size: 14, weight: .semibold)
}
