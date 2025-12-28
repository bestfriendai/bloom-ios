//
//  SubmitCheckInUseCase.swift
//  Bloom
//
//  Use case for submitting daily check-ins
//

import Foundation

/// Use case for submitting a daily check-in with AI insight generation
final class SubmitCheckInUseCase: Sendable {
    private let checkInRepository: CheckInRepositoryProtocol
    private let aiRepository: AIInsightRepositoryProtocol
    private let userRepository: UserRepositoryProtocol

    init(
        checkInRepository: CheckInRepositoryProtocol,
        aiRepository: AIInsightRepositoryProtocol,
        userRepository: UserRepositoryProtocol
    ) {
        self.checkInRepository = checkInRepository
        self.aiRepository = aiRepository
        self.userRepository = userRepository
    }

    /// Executes the check-in submission
    /// - Parameters:
    ///   - checkIn: The check-in data to submit
    ///   - userGoals: User's wellness goals for personalized insight
    /// - Returns: The generated AI insight
    func execute(checkIn: DailyCheckIn, userGoals: [WellnessGoalType]) async throws -> String {
        // Validate check-in
        guard checkIn.isValid else {
            throw CheckInError.invalidData
        }

        // Check if already checked in today
        if let existing = try await checkInRepository.getTodayCheckIn(userId: checkIn.userId) {
            if existing.isFromToday() {
                throw CheckInError.alreadyCheckedInToday
            }
        }

        // Save check-in
        try await checkInRepository.save(checkIn)

        // Generate AI insight
        let insight: String
        do {
            insight = try await aiRepository.generateInsight(for: checkIn, userGoals: userGoals)
            try await checkInRepository.updateInsight(id: checkIn.id, insight: insight)
        } catch {
            // If AI fails, provide a fallback insight
            insight = generateFallbackInsight(for: checkIn)
        }

        // Update streak
        let streak = try await checkInRepository.getStreak(userId: checkIn.userId)
        try await userRepository.updateStreak(userId: checkIn.userId, streak: streak)

        return insight
    }

    private func generateFallbackInsight(for checkIn: DailyCheckIn) -> String {
        if checkIn.overallWellnessScore >= 7 {
            return "Great job on your check-in! Your wellness scores are looking strong today. Keep up the positive momentum!"
        } else if checkIn.overallWellnessScore >= 5 {
            return "Thanks for checking in. Remember that small consistent steps lead to big improvements. You're doing great by staying aware of your wellness."
        } else {
            return "It looks like today might be a challenging day. Remember to be gentle with yourself. Even small acts of self-care can make a difference."
        }
    }
}
