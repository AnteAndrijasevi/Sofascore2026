//
//  Colors.swift
//  Sofascore2026
//
//  Created by Ante Andrijašević on 10/03/2026.
//

import UIKit

enum AppColors {
    static let primaryText = UIColor(hex: "#121212")
    static let secondaryText = UIColor(hex: "#121212").withAlphaComponent(0.4)
    static let surface = UIColor.white
    static let liveRed = UIColor(hex: "#E8282B")
}

extension UIColor {
    convenience init(hex: String) {
        var hexStr = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexStr = hexStr.hasPrefix("#") ? String(hexStr.dropFirst()) : hexStr
        var rgb: UInt64 = 0
        Scanner(string: hexStr).scanHexInt64(&rgb)
        self.init(
            red: CGFloat((rgb >> 16) & 0xFF) / 255,
            green: CGFloat((rgb >> 8) & 0xFF) / 255,
            blue: CGFloat(rgb & 0xFF) / 255,
            alpha: 1.0
        )
    }
}
