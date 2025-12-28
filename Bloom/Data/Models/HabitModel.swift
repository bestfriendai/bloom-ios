//
//  HabitModel.swift
//  Bloom
//
//  SwiftData model for habit persistence
//

import Foundation
import SwiftData

@Model
final class HabitModel {
    @Attribute(.unique) var id: String
    var userId: String
    var name: String
    var icon: String
    var color: String
    var createdAt: Date
    var completedDates: [Date]
    var currentStreak: Int
    var longestStreak: Int
    var isActive: Bool
    var isSynced: Bool

    init(
        id: String = UUID().uuidString,
        userId: String,
        name: String,
        icon: String,
        color: String,
        createdAt: Date = Date(),
        completedDates: [Date] = [],
        currentStreak: Int = 0,
        longestStreak: Int = 0,
        isActive: Bool = true,
        isSynced: Bool = false
    ) {
        self.id = id
        self.userId = userId
        self.name = name
        self.icon = icon
        self.color = color
        self.createdAt = createdAt
        self.completedDates = completedDates
        self.currentStreak = currentStreak
        self.longestStreak = longestStreak
        self.isActive = isActive
        self.isSynced = isSynced
    }
}

// MARK: - Domain Conversion

extension HabitModel {
    func toDomain() -> Habit {
        Habit(
            id: id,
            userId: userId,
            name: name,
            icon: icon,
            color: color,
            createdAt: createdAt,
            completedDates: completedDates,
            currentStreak: currentStreak,
            longestStreak: longestStreak,
            isActive: isActive
        )
    }

    convenience init(from domain: Habit) {
        self.init(
            id: domain.id,
            userId: domain.userId,
            name: domain.name,
            icon: domain.icon,
            color: domain.color,
            createdAt: domain.createdAt,
            completedDates: domain.completedDates,
            currentStreak: domain.currentStreak,
            longestStreak: domain.longestStreak,
            isActive: domain.isActive
        )
    }
}
