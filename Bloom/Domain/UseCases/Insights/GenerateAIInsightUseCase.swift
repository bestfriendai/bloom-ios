//
//  GenerateAIInsightUseCase.swift
//  Bloom
//
//  Use case for generating AI-powered wellness insights
//

import Foundation

/// Use case for generating personalized AI insights
final class GenerateAIInsightUseCase: Sendable {
    private let aiRepository: AIInsightRepositoryProtocol
    private let userRepository: UserRepositoryProtocol

    init(aiRepository: AIInsightRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.aiRepository = aiRepository
        self.userRepository = userRepository
    }

    /// Generates an insight for a check-in
    /// - Parameters:
    ///   - checkIn: The check-in to generate insight for
    ///   - userId: The user's ID
    /// - Returns: The generated insight text
    func execute(for checkIn: DailyCheckIn, userId: String) async throws -> String {
        // Get user to check subscription and goals
        let user = try await userRepository.getUser(id: userId)

        // Check rate limit for free users
        if user.subscriptionTier == .free {
            let remaining = try await aiRepository.getRemainingFreeInsights(userId: userId)
            if remaining <= 0 {
                throw AIInsightError.rateLimitExceeded
            }
        }

        // Convert goal strings to WellnessGoalType
        let goals = user.wellnessGoals.compactMap { goalString in
            WellnessGoalType.allCases.first { $0.rawValue == goalString }
        }

        return try await aiRepository.generateInsight(for: checkIn, userGoals: goals)
    }
}
