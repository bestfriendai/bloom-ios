//
//  WellnessGoal.swift
//  Bloom
//
//  Created on 2025-12-03.
//

import Foundation
import SwiftUI

/// Represents a user's wellness goal for personalized coaching
struct WellnessGoal {

    private let colorComponents: (red: Double, green: Double, blue: Double, opacity: Double)

    let id: String
    var userId: String
    let type: WellnessGoalType
    let targetValue: Double?
    let createdAt: Date
    var isActive: Bool

    var color: Color {
        Color(red: colorComponents.red,
              green: colorComponents.green,
              blue: colorComponents.blue).opacity(colorComponents.opacity)
    }

    init(
        id: String = UUID().uuidString,
        userId: String = "",
        type: WellnessGoalType,
        color: Color,
        targetValue: Double? = nil,
        createdAt: Date = Date(),
        isActive: Bool = true
    ) {
        self.id = id
        self.userId = userId
        self.type = type
        self.colorComponents = color.rgbaComponents()
        self.targetValue = targetValue
        self.createdAt = createdAt
        self.isActive = isActive
    }
}

fileprivate extension Color {
    struct RGBA: Hashable { let r: Double; let g: Double; let b: Double; let a: Double }

    func rgbaComponents() -> (red: Double, green: Double, blue: Double, opacity: Double) {
        #if canImport(UIKit)
        let ui = UIColor(self)
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        if ui.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return (Double(r), Double(g), Double(b), Double(a))
        }
        // Fallback for non-RGB compatible colors
        var white: CGFloat = 0
        if ui.getWhite(&white, alpha: &a) {
            return (Double(white), Double(white), Double(white), Double(a))
        }
        return (0, 0, 0, 0)
        #elseif canImport(AppKit)
        let ns = NSColor(self)
        let converted = ns.usingColorSpace(.deviceRGB) ?? ns
        return (Double(converted.redComponent), Double(converted.greenComponent), Double(converted.blueComponent), Double(converted.alphaComponent))
        #else
        // Best-effort default
        return (0, 0, 0, 1)
        #endif
    }
}

/// Types of wellness goals users can select
enum WellnessGoalType: String, Codable, CaseIterable {
    case improveSleep = "Improve Sleep"
    case reduceStress = "Reduce Stress"
    case increaseEnergy = "Increase Energy"
    case betterMood = "Better Mood"
    case buildHabits = "Build Healthy Habits"
    case mindfulness = "Practice Mindfulness"
    case workLifeBalance = "Work-Life Balance"
    case physicalHealth = "Physical Health"
    case mentalHealth = "Mental Health"
    case productivity = "Productivity"

    /// SF Symbol name for use with Image(systemName:)
    var icon: String {
        switch self {
        case .improveSleep: return "moon.zzz.fill"
        case .reduceStress: return "leaf.fill"
        case .increaseEnergy: return "bolt.fill"
        case .betterMood: return "face.smiling.fill"
        case .buildHabits: return "checkmark.circle.fill"
        case .mindfulness: return "sparkles"
        case .workLifeBalance: return "scale.3d"
        case .physicalHealth: return "figure.run"
        case .mentalHealth: return "brain.head.profile"
        case .productivity: return "target"
        }
    }

    /// Emoji representation for display in text contexts
    var emoji: String {
        switch self {
        case .improveSleep: return "😴"
        case .reduceStress: return "🧘"
        case .increaseEnergy: return "⚡️"
        case .betterMood: return "😊"
        case .buildHabits: return "✅"
        case .mindfulness: return "🌸"
        case .workLifeBalance: return "⚖️"
        case .physicalHealth: return "💪"
        case .mentalHealth: return "🧠"
        case .productivity: return "🎯"
        }
    }

    var defaultDescription: String {
        switch self {
        case .improveSleep:
            return "Get better quality sleep and wake up refreshed"
        case .reduceStress:
            return "Manage stress and find calm in daily life"
        case .increaseEnergy:
            return "Boost energy levels throughout the day"
        case .betterMood:
            return "Cultivate a more positive emotional state"
        case .buildHabits:
            return "Establish consistent healthy routines"
        case .mindfulness:
            return "Be more present and aware in daily activities"
        case .workLifeBalance:
            return "Find harmony between work and personal life"
        case .physicalHealth:
            return "Improve overall physical wellbeing"
        case .mentalHealth:
            return "Enhance mental clarity and emotional resilience"
        case .productivity:
            return "Accomplish goals with focus and efficiency"
        }
    }

    /// Returns coaching context for AI to personalize insights
    var coachingContext: String {
        switch self {
        case .improveSleep:
            return "Focus on sleep hygiene, bedtime routines, and factors affecting sleep quality."
        case .reduceStress:
            return "Emphasize stress management techniques, relaxation, and healthy coping mechanisms."
        case .increaseEnergy:
            return "Highlight energy-boosting habits like movement, nutrition, and rest patterns."
        case .betterMood:
            return "Support mood regulation through activities, social connection, and self-care."
        case .buildHabits:
            return "Encourage consistency, celebrate small wins, and provide accountability."
        case .mindfulness:
            return "Promote present-moment awareness and mindful practices."
        case .workLifeBalance:
            return "Address boundaries, time management, and life satisfaction."
        case .physicalHealth:
            return "Encourage movement, nutrition, and physical self-care."
        case .mentalHealth:
            return "Support emotional wellbeing, cognitive health, and mental resilience."
        case .productivity:
            return "Focus on focus, energy management, and effective goal-setting."
        }
    }
}

extension WellnessGoal: Equatable {
    static func == (lhs: WellnessGoal, rhs: WellnessGoal) -> Bool { lhs.id == rhs.id }
}

extension WellnessGoal: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension WellnessGoal: Identifiable {}
