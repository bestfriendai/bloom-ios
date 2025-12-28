//
//  WellnessGoalModel.swift
//  Bloom
//
//  SwiftData model for wellness goal persistence
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class WellnessGoalModel {
    @Attribute(.unique) var id: String
    var userId: String
    var typeRaw: String
    var colorRed: Double
    var colorGreen: Double
    var colorBlue: Double
    var colorOpacity: Double
    var targetValue: Double?
    var createdAt: Date
    var isActive: Bool

    init(
        id: String = UUID().uuidString,
        userId: String = "",
        typeRaw: String,
        colorRed: Double = 0,
        colorGreen: Double = 0,
        colorBlue: Double = 0,
        colorOpacity: Double = 1,
        targetValue: Double? = nil,
        createdAt: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.userId = userId
        self.typeRaw = typeRaw
        self.colorRed = colorRed
        self.colorGreen = colorGreen
        self.colorBlue = colorBlue
        self.colorOpacity = colorOpacity
        self.targetValue = targetValue
        self.createdAt = createdAt
        self.isActive = isActive
    }

    var goalType: WellnessGoalType? {
        WellnessGoalType(rawValue: typeRaw)
    }

    var color: Color {
        Color(red: colorRed, green: colorGreen, blue: colorBlue).opacity(colorOpacity)
    }
}

// MARK: - Domain Conversion

extension WellnessGoalModel {
    func toDomain() -> WellnessGoal? {
        guard let type = goalType else { return nil }
        return WellnessGoal(
            id: id,
            userId: userId,
            type: type,
            color: color,
            targetValue: targetValue,
            createdAt: createdAt,
            isActive: isActive
        )
    }

    convenience init(from domain: WellnessGoal) {
        // Extract color components
        let uiColor = UIColor(domain.color)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        self.init(
            id: domain.id,
            userId: domain.userId,
            typeRaw: domain.type.rawValue,
            colorRed: Double(r),
            colorGreen: Double(g),
            colorBlue: Double(b),
            colorOpacity: Double(a),
            targetValue: domain.targetValue,
            createdAt: domain.createdAt,
            isActive: domain.isActive
        )
    }
}
