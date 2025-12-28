//
//  AIInsightRepository.swift
//  Bloom
//
//  Repository implementation for AI-powered insights
//  Uses mock responses for development - replace with OpenAI/Claude API for production
//

import Foundation

/// Mock implementation of AIInsightRepositoryProtocol
final class AIInsightRepository: AIInsightRepositoryProtocol, @unchecked Sendable {

    init() {}

    func generateInsight(for checkIn: DailyCheckIn, userGoals: [WellnessGoalType]) async throws -> String {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 1_500_000_000)

        // Generate personalized insight based on check-in data
        return generatePersonalizedInsight(checkIn: checkIn, goals: userGoals)
    }

    func generateWeeklyAnalysis(checkIns: [DailyCheckIn], habits: [Habit]) async throws -> WeeklyAnalysis {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 2_000_000_000)

        return WeeklyAnalysis(
            summary: "This week you showed consistent dedication to your wellness journey. Your average mood was \(calculateAverage(checkIns.map { $0.moodScore }))/10 with \(checkIns.count) check-ins.",
            moodInsights: "Your mood tends to be highest on days when you get 7+ hours of sleep. Consider maintaining a consistent sleep schedule.",
            energyInsights: "Your energy levels peak in the mornings. Try scheduling important tasks during this time.",
            sleepInsights: "You averaged \(String(format: "%.1f", calculateAverageSleep(checkIns))) hours of sleep this week. Aim for 7-8 hours for optimal wellness.",
            recommendations: [
                "Try a 10-minute morning meditation to start your day",
                "Take a short walk after lunch to boost afternoon energy",
                "Set a consistent bedtime to improve sleep quality"
            ],
            highlightHabit: habits.first?.name,
            generatedAt: Date()
        )
    }

    func chat(message: String, context: ChatContext) async throws -> String {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Generate contextual response
        return generateChatResponse(message: message, context: context)
    }

    func getPersonalizedTips(for user: UserProfile, recentCheckIns: [DailyCheckIn]) async throws -> [WellnessTip] {
        // Simulate API delay
        try await Task.sleep(nanoseconds: 500_000_000)

        var tips: [WellnessTip] = []

        // Generate tips based on user goals
        for goalString in user.wellnessGoals {
            if let goalType = WellnessGoalType.allCases.first(where: { $0.rawValue == goalString }) {
                tips.append(generateTip(for: goalType))
            }
        }

        // Add general wellness tips if needed
        if tips.count < 3 {
            tips.append(WellnessTip(
                id: UUID().uuidString,
                title: "Stay Hydrated",
                description: "Drinking enough water can improve your mood and energy levels.",
                category: .physicalHealth,
                actionable: "Set reminders to drink water every 2 hours"
            ))
        }

        return tips
    }

    func getRemainingFreeInsights(userId: String) async throws -> Int {
        // In production, this would check against a database
        // For now, return a mock value
        return 3
    }

    // MARK: - Private Helpers

    private func generatePersonalizedInsight(checkIn: DailyCheckIn, goals: [WellnessGoalType]) -> String {
        let overallScore = checkIn.overallWellnessScore

        var insight = ""

        if overallScore >= 8 {
            insight = "Excellent day! Your wellness scores are thriving. "
        } else if overallScore >= 6 {
            insight = "Good progress today! You're maintaining a solid foundation. "
        } else if overallScore >= 4 {
            insight = "Every day is a fresh start. Small steps lead to big changes. "
        } else {
            insight = "I hear you - some days are tougher than others. Be gentle with yourself. "
        }

        // Add goal-specific advice
        if let primaryGoal = goals.first {
            switch primaryGoal {
            case .improveSleep:
                if checkIn.sleepHours < 7 {
                    insight += "Consider starting your wind-down routine 30 minutes earlier tonight."
                } else {
                    insight += "Great sleep last night! Keep up the consistent routine."
                }
            case .reduceStress:
                insight += "Try a 5-minute breathing exercise if you feel tension building."
            case .increaseEnergy:
                if checkIn.energyScore < 5 {
                    insight += "A short walk or stretch could help boost your energy right now."
                } else {
                    insight += "Your energy is solid - channel it into something meaningful today."
                }
            case .betterMood:
                insight += "Remember: acknowledging how you feel is the first step to feeling better."
            default:
                insight += "You're making progress on your wellness journey."
            }
        }

        return insight
    }

    private func generateChatResponse(message: String, context: ChatContext) -> String {
        let lowercasedMessage = message.lowercased()

        if lowercasedMessage.contains("sleep") {
            return "Sleep is foundational to wellness. Based on your recent check-ins, I'd recommend establishing a consistent bedtime routine. Would you like some specific tips for better sleep?"
        } else if lowercasedMessage.contains("stress") || lowercasedMessage.contains("anxious") {
            return "I understand feeling stressed can be overwhelming. Let's work through this together. Have you tried any breathing exercises today? Even 3 deep breaths can activate your body's relaxation response."
        } else if lowercasedMessage.contains("energy") || lowercasedMessage.contains("tired") {
            return "Low energy can have many causes - sleep, nutrition, hydration, or activity levels. Based on your patterns, you might benefit from a short walk or a healthy snack. What sounds manageable right now?"
        } else if lowercasedMessage.contains("habit") {
            return "Building habits takes time and consistency. The key is starting small and being patient with yourself. Which habit would you like to focus on today?"
        } else {
            return "Thank you for sharing that with me. Remember, wellness is a journey, not a destination. What aspect of your wellbeing would you like to focus on today?"
        }
    }

    private func generateTip(for goalType: WellnessGoalType) -> WellnessTip {
        switch goalType {
        case .improveSleep:
            return WellnessTip(
                id: UUID().uuidString,
                title: "Evening Wind-Down",
                description: "Create a relaxing pre-sleep routine to signal your body it's time to rest.",
                category: .improveSleep,
                actionable: "Dim lights and avoid screens 30 minutes before bed"
            )
        case .reduceStress:
            return WellnessTip(
                id: UUID().uuidString,
                title: "Mindful Breathing",
                description: "Regular breathing exercises can significantly reduce stress levels.",
                category: .reduceStress,
                actionable: "Practice 4-7-8 breathing: inhale 4s, hold 7s, exhale 8s"
            )
        case .increaseEnergy:
            return WellnessTip(
                id: UUID().uuidString,
                title: "Movement Breaks",
                description: "Short bursts of activity throughout the day boost energy naturally.",
                category: .increaseEnergy,
                actionable: "Take a 5-minute walk every 2 hours"
            )
        default:
            return WellnessTip(
                id: UUID().uuidString,
                title: "Daily Reflection",
                description: "Taking time to reflect on your day improves self-awareness.",
                category: goalType,
                actionable: "Spend 5 minutes journaling before bed"
            )
        }
    }

    private func calculateAverage(_ values: [Int]) -> Double {
        guard !values.isEmpty else { return 0 }
        return Double(values.reduce(0, +)) / Double(values.count)
    }

    private func calculateAverageSleep(_ checkIns: [DailyCheckIn]) -> Double {
        guard !checkIns.isEmpty else { return 0 }
        return checkIns.reduce(0) { $0 + $1.sleepHours } / Double(checkIns.count)
    }
}
