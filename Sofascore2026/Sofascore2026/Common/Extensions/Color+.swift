import SwiftUI
import UIKit

extension Color {
    init(hex: String) {
        self.init(UIColor(hex: hex))
    }
}
