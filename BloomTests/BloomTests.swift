//
//  BloomTests.swift
//  BloomTests
//
//  Unit tests for Bloom wellness app
//

import Testing
import Foundation
@testable import Bloom

// MARK: - Domain Entity Tests

struct DailyCheckInTests {

    @Test func testCheckInCreation() {
        let checkIn = DailyCheckIn(
            id: "test-123",
            userId: "user-456",
            timestamp: Date(),
            moodScore: 7,
            energyScore: 6,
            sleepHours: 7.5,
            sleepQuality: 8,
            notes: "Feeling good",
            aiInsight: nil,
            isMorning: true
        )

        #expect(checkIn.id == "test-123")
        #expect(checkIn.userId == "user-456")
        #expect(checkIn.moodScore == 7)
        #expect(checkIn.energyScore == 6)
        #expect(checkIn.sleepHours == 7.5)
        #expect(checkIn.sleepQuality == 8)
        #expect(checkIn.isMorning == true)
    }

    @Test func testOverallWellnessScore() {
        // High scores
        let highCheckIn = DailyCheckIn(
            id: "high",
            userId: "user",
            timestamp: Date(),
            moodScore: 9,
            energyScore: 8,
            sleepHours: 8,
            sleepQuality: 9,
            notes: nil,
            aiInsight: nil,
            isMorning: true
        )

        let highScore = highCheckIn.overallWellnessScore
        #expect(highScore >= 8)

        // Low scores
        let lowCheckIn = DailyCheckIn(
            id: "low",
            userId: "user",
            timestamp: Date(),
            moodScore: 2,
            energyScore: 3,
            sleepHours: 4,
            sleepQuality: 2,
            notes: nil,
            aiInsight: nil,
            isMorning: true
        )

        let lowScore = lowCheckIn.overallWellnessScore
        #expect(lowScore < 5)
    }
}

struct UserProfileTests {

    @Test func testUserProfileCreation() {
        let user = UserProfile(
            id: "user-123",
            email: "test@example.com",
            displayName: "Test User"
        )

        #expect(user.id == "user-123")
        #expect(user.email == "test@example.com")
        #expect(user.displayName == "Test User")
        #expect(user.subscriptionTier == .free)
        #expect(user.wellnessGoals.isEmpty)
        #expect(user.checkInStreak == 0)
    }

    @Test func testPremiumUser() {
        var user = UserProfile(
            id: "premium-user",
            email: "premium@example.com",
            displayName: "Premium User"
        )

        #expect(user.subscriptionTier == .free)

        user = UserProfile(
            id: user.id,
            email: user.email,
            displayName: user.displayName,
            createdAt: user.createdAt,
            subscriptionTier: .premium,
            wellnessGoals: user.wellnessGoals,
            checkInStreak: user.checkInStreak,
            hasCompletedOnboarding: user.hasCompletedOnboarding
        )

        #expect(user.subscriptionTier == .premium)
    }
}

struct HabitTests {

    @Test func testHabitCreation() {
        let habit = Habit(
            id: "habit-123",
            userId: "user-456",
            name: "Morning Meditation",
            icon: "🧘",
            color: "#4DB6AC",
            createdAt: Date()
        )

        #expect(habit.id == "habit-123")
        #expect(habit.name == "Morning Meditation")
        #expect(habit.isActive == true)
        #expect(habit.currentStreak == 0)
        #expect(habit.longestStreak == 0)
        #expect(habit.completedDates.isEmpty)
    }

    @Test func testHabitCompletion() {
        var habit = Habit(
            id: "habit-123",
            userId: "user-456",
            name: "Exercise",
            icon: "🏃",
            color: "#FF8A65",
            createdAt: Date()
        )

        let today = Date()
        habit.completedDates.append(today)
        habit.currentStreak = 1

        #expect(habit.completedDates.count == 1)
        #expect(habit.currentStreak == 1)
    }

    @Test func testLongestStreakTracking() {
        var habit = Habit(
            id: "habit-123",
            userId: "user-456",
            name: "Reading",
            icon: "📚",
            color: "#81C784",
            createdAt: Date()
        )

        habit.currentStreak = 5
        habit.longestStreak = 10

        #expect(habit.longestStreak >= habit.currentStreak)
    }
}

struct WellnessGoalTests {

    @Test func testAllGoalTypesHaveIcons() {
        for goalType in WellnessGoalType.allCases {
            let icon = goalType.icon
            #expect(!icon.isEmpty, "Goal type \(goalType) should have an icon")
        }
    }

    @Test func testAllGoalTypesHaveEmojis() {
        for goalType in WellnessGoalType.allCases {
            let emoji = goalType.emoji
            #expect(!emoji.isEmpty, "Goal type \(goalType) should have an emoji")
        }
    }

    @Test func testAllGoalTypesHaveDescriptions() {
        for goalType in WellnessGoalType.allCases {
            let description = goalType.description
            #expect(!description.isEmpty, "Goal type \(goalType) should have a description")
        }
    }

    @Test func testWellnessGoalCreation() {
        let goal = WellnessGoal(
            id: "goal-123",
            type: .improveSleep,
            targetValue: 8.0,
            currentProgress: 6.5,
            isActive: true
        )

        #expect(goal.type == .improveSleep)
        #expect(goal.targetValue == 8.0)
        #expect(goal.currentProgress == 6.5)
        #expect(goal.isActive == true)
    }
}

// MARK: - Password Validation Tests

struct PasswordValidationTests {

    @Test func testPasswordRequirementsInitialState() {
        let requirements = PasswordRequirements()

        #expect(requirements.hasMinLength == false)
        #expect(requirements.hasUppercase == false)
        #expect(requirements.hasNumber == false)
    }

    @Test func testPasswordMinLength() {
        var req = PasswordRequirements()
        req.hasMinLength = "12345678".count >= 8

        #expect(req.hasMinLength == true)
    }

    @Test func testPasswordWithUppercase() {
        let password = "Password123"
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil

        #expect(hasUppercase == true)
    }

    @Test func testPasswordWithNumber() {
        let password = "Password123"
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil

        #expect(hasNumber == true)
    }

    @Test func testWeakPassword() {
        let password = "weak"

        let meetsLength = password.count >= 8
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil

        #expect(meetsLength == false)
        #expect(hasUppercase == false)
        #expect(hasNumber == false)
    }

    @Test func testStrongPassword() {
        let password = "SecurePass123!"

        let meetsLength = password.count >= 8
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil

        #expect(meetsLength == true)
        #expect(hasUppercase == true)
        #expect(hasNumber == true)
    }
}

// MARK: - Weekly Stats Tests

struct WeeklyStatsTests {

    @Test func testEmptyStats() {
        let stats = WeeklyCheckInStats(
            totalCheckIns: 0,
            averageMood: 0,
            averageEnergy: 0,
            averageSleepHours: 0,
            averageSleepQuality: 0,
            moodTrend: .stable,
            energyTrend: .stable
        )

        #expect(stats.totalCheckIns == 0)
        #expect(stats.moodTrend == .stable)
    }

    @Test func testTrendCalculation() {
        let improvingStats = WeeklyCheckInStats(
            totalCheckIns: 7,
            averageMood: 7.5,
            averageEnergy: 7.0,
            averageSleepHours: 7.5,
            averageSleepQuality: 8,
            moodTrend: .improving,
            energyTrend: .improving
        )

        #expect(improvingStats.moodTrend == .improving)
        #expect(improvingStats.energyTrend == .improving)
    }

    @Test func testDecliningTrend() {
        let decliningStats = WeeklyCheckInStats(
            totalCheckIns: 7,
            averageMood: 4.0,
            averageEnergy: 3.5,
            averageSleepHours: 5.5,
            averageSleepQuality: 4,
            moodTrend: .declining,
            energyTrend: .declining
        )

        #expect(decliningStats.moodTrend == .declining)
        #expect(decliningStats.energyTrend == .declining)
    }
}

// MARK: - Habit Correlation Tests

struct HabitCorrelationTests {

    @Test func testCorrelationCreation() {
        let correlation = HabitCorrelation(
            habitId: "habit-123",
            habitName: "Meditation",
            moodCorrelation: 0.75,
            energyCorrelation: 0.60,
            sleepCorrelation: 0.45,
            sampleSize: 30
        )

        #expect(correlation.habitName == "Meditation")
        #expect(correlation.moodCorrelation == 0.75)
        #expect(correlation.sampleSize == 30)
    }

    @Test func testCorrelationBounds() {
        let correlation = HabitCorrelation(
            habitId: "habit-123",
            habitName: "Exercise",
            moodCorrelation: 0.85,
            energyCorrelation: -0.25,
            sleepCorrelation: 0.50,
            sampleSize: 14
        )

        // Correlations should be between -1 and 1
        #expect(correlation.moodCorrelation >= -1 && correlation.moodCorrelation <= 1)
        #expect(correlation.energyCorrelation >= -1 && correlation.energyCorrelation <= 1)
        #expect(correlation.sleepCorrelation >= -1 && correlation.sleepCorrelation <= 1)
    }
}

// MARK: - Weekly Analysis Tests

struct WeeklyAnalysisTests {

    @Test func testWeeklyAnalysisCreation() {
        let analysis = WeeklyAnalysis(
            summary: "Great week overall!",
            moodInsights: "Your mood improved significantly.",
            energyInsights: "Energy levels were consistent.",
            sleepInsights: "Sleep quality was good.",
            recommendations: ["Keep up the good work", "Try morning exercise"],
            highlightHabit: "Meditation",
            generatedAt: Date()
        )

        #expect(analysis.summary == "Great week overall!")
        #expect(analysis.recommendations.count == 2)
        #expect(analysis.highlightHabit == "Meditation")
    }

    @Test func testWeeklyAnalysisWithoutHighlight() {
        let analysis = WeeklyAnalysis(
            summary: "First week of tracking.",
            moodInsights: "Getting started.",
            energyInsights: "Building baseline.",
            sleepInsights: "Tracking sleep.",
            recommendations: ["Start a habit"],
            highlightHabit: nil,
            generatedAt: Date()
        )

        #expect(analysis.highlightHabit == nil)
    }
}

// MARK: - Wellness Tip Tests

struct WellnessTipTests {

    @Test func testWellnessTipCreation() {
        let tip = WellnessTip(
            id: "tip-123",
            title: "Morning Routine",
            description: "Start your day with intention.",
            category: .improveSleep,
            actionable: "Wake up at the same time daily."
        )

        #expect(tip.title == "Morning Routine")
        #expect(tip.category == .improveSleep)
        #expect(!tip.actionable.isEmpty)
    }
}

// MARK: - Subscription Tier Tests

struct SubscriptionTierTests {

    @Test func testFreeTier() {
        let tier = SubscriptionTier.free

        #expect(tier.rawValue == "free")
    }

    @Test func testPremiumTier() {
        let tier = SubscriptionTier.premium

        #expect(tier.rawValue == "premium")
    }

    @Test func testTierFromRawValue() {
        let freeTier = SubscriptionTier(rawValue: "free")
        let premiumTier = SubscriptionTier(rawValue: "premium")
        let invalidTier = SubscriptionTier(rawValue: "invalid")

        #expect(freeTier == .free)
        #expect(premiumTier == .premium)
        #expect(invalidTier == nil)
    }
}

// MARK: - Date Helper Tests

struct DateHelperTests {

    @Test func testStartOfDay() {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)

        let components = calendar.dateComponents([.hour, .minute, .second], from: startOfDay)

        #expect(components.hour == 0)
        #expect(components.minute == 0)
        #expect(components.second == 0)
    }

    @Test func testSameDayComparison() {
        let calendar = Calendar.current
        let now = Date()
        let laterToday = calendar.date(byAdding: .hour, value: 2, to: now)!

        let isSameDay = calendar.isDate(now, inSameDayAs: laterToday)

        #expect(isSameDay == true)
    }

    @Test func testDifferentDayComparison() {
        let calendar = Calendar.current
        let now = Date()
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: now)!

        let isSameDay = calendar.isDate(now, inSameDayAs: tomorrow)

        #expect(isSameDay == false)
    }
}

// MARK: - Chat Context Tests

struct ChatContextTests {

    @Test func testChatContextCreation() {
        let context = ChatContext(
            userId: "user-123",
            recentCheckIns: [],
            activeHabits: [],
            currentStreak: 5
        )

        #expect(context.userId == "user-123")
        #expect(context.currentStreak == 5)
        #expect(context.recentCheckIns.isEmpty)
    }
}
