import UIKit

extension UIColor {
    convenience init(hex: String) {
            var hexStr = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexStr = hexStr.hasPrefix("#") ? String(hexStr.dropFirst()) : hexStr

            var rgb: UInt64 = 0
            guard hexStr.count == 6, Scanner(string: hexStr).scanHexInt64(&rgb) else {
                assertionFailure("Expected 6-digit hex string, got: \(hexStr)")
                self.init(red: 0, green: 0, blue: 0, alpha: 1)
                return
            }

            self.init(
                red: CGFloat((rgb >> 16) & 0xFF) / 255,
                green: CGFloat((rgb >> 8) & 0xFF) / 255,
                blue: CGFloat(rgb & 0xFF) / 255,
                alpha: 1.0
            )
        }
}
