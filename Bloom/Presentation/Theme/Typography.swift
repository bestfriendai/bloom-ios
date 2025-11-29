//
//  Typography.swift
//  Bloom
//
//  Design system typography
//

import SwiftUI

extension Font {
    // MARK: - Display
    static let bloomDisplayLarge = Font.system(size: 57, weight: .bold, design: .rounded)
    static let bloomDisplayMedium = Font.system(size: 45, weight: .bold, design: .rounded)
    static let bloomDisplaySmall = Font.system(size: 36, weight: .bold, design: .rounded)

    // MARK: - Headline
    static let bloomHeadlineLarge = Font.system(size: 32, weight: .semibold, design: .rounded)
    static let bloomHeadlineMedium = Font.system(size: 28, weight: .semibold, design: .rounded)
    static let bloomHeadlineSmall = Font.system(size: 24, weight: .semibold, design: .rounded)

    // MARK: - Title
    static let bloomTitleLarge = Font.system(size: 22, weight: .medium, design: .rounded)
    static let bloomTitleMedium = Font.system(size: 16, weight: .medium, design: .rounded)
    static let bloomTitleSmall = Font.system(size: 14, weight: .medium, design: .rounded)

    // MARK: - Body
    static let bloomBodyLarge = Font.system(size: 17, weight: .regular, design: .rounded)
    static let bloomBodyMedium = Font.system(size: 15, weight: .regular, design: .rounded)
    static let bloomBodySmall = Font.system(size: 13, weight: .regular, design: .rounded)

    // MARK: - Label
    static let bloomLabelLarge = Font.system(size: 14, weight: .medium, design: .rounded)
    static let bloomLabelMedium = Font.system(size: 12, weight: .medium, design: .rounded)
    static let bloomLabelSmall = Font.system(size: 11, weight: .medium, design: .rounded)
}
