//
//  Colors.swift
//  Bloom
//
//  Design system colors following iOS HIG
//

import SwiftUI

extension Color {
    // MARK: - Primary Colors
    static let bloomTeal = Color(hex: "4DB6AC")
    static let bloomCoral = Color(hex: "FF8A65")
    static let bloomGreen = Color(hex: "81C784")

    // MARK: - Background Colors
    static let bloomBackground = Color(hex: "FAFAFA")
    static let bloomBackgroundDark = Color(hex: "121212")

    // MARK: - Semantic Colors
    static let bloomPrimary = bloomTeal
    static let bloomSecondary = bloomCoral
    static let bloomSuccess = bloomGreen

    // MARK: - Adaptive Background
    static let bloomAdaptiveBackground = Color(
        light: bloomBackground,
        dark: bloomBackgroundDark
    )

    // MARK: - Text Colors
    static let bloomTextPrimary = Color(
        light: Color(hex: "1A1A1A"),
        dark: Color(hex: "F5F5F5")
    )

    static let bloomTextSecondary = Color(
        light: Color(hex: "666666"),
        dark: Color(hex: "AAAAAA")
    )

    // MARK: - Card Colors
    static let bloomCard = Color(
        light: .white,
        dark: Color(hex: "1E1E1E")
    )

    // MARK: - Gradient
    static let bloomGradient = LinearGradient(
        colors: [bloomTeal, bloomCoral],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    // MARK: - Helper Initializers
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor(light: UIColor(light), dark: UIColor(dark)))
    }
}

extension UIColor {
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}
