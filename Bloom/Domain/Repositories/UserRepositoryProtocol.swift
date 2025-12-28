//
//  UserRepositoryProtocol.swift
//  Bloom
//
//  Repository protocol for user profile operations
//

import Foundation

/// Errors that can occur during user operations
enum UserError: Error, LocalizedError {
    case userNotFound
    case updateFailed
    case networkError
    case unauthorized
    case invalidData

    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found"
        case .updateFailed:
            return "Failed to update user profile"
        case .networkError:
            return "Network error. Please check your connection"
        case .unauthorized:
            return "You are not authorized to perform this action"
        case .invalidData:
            return "Invalid data provided"
        }
    }
}

/// Protocol defining user repository operations
protocol UserRepositoryProtocol: Sendable {
    /// Fetches a user profile by ID
    func getUser(id: String) async throws -> UserProfile

    /// Updates user profile information
    func updateUser(_ user: UserProfile) async throws

    /// Updates user's check-in streak
    func updateStreak(userId: String, streak: Int) async throws

    /// Updates user's wellness goals
    func updateWellnessGoals(userId: String, goals: [String]) async throws

    /// Updates user's subscription tier
    func updateSubscriptionTier(userId: String, tier: SubscriptionTier) async throws

    /// Deletes user account and all associated data
    func deleteUser(id: String) async throws

    /// Marks onboarding as completed for user
    func completeOnboarding(userId: String) async throws

    /// Checks if user has completed onboarding
    func hasCompletedOnboarding(userId: String) async throws -> Bool
}
