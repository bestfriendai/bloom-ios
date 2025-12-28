//
//  UserRepository.swift
//  Bloom
//
//  Repository implementation for user profile operations
//

import Foundation

/// Implementation of UserRepositoryProtocol
final class UserRepository: UserRepositoryProtocol, @unchecked Sendable {
    private let localDataSource: LocalUserDataSource

    init(localDataSource: LocalUserDataSource = LocalUserDataSource()) {
        self.localDataSource = localDataSource
    }

    func getUser(id: String) async throws -> UserProfile {
        guard let model = try await localDataSource.getUser(id: id) else {
            throw UserError.userNotFound
        }
        return model.toDomain()
    }

    func updateUser(_ user: UserProfile) async throws {
        guard let model = try await localDataSource.getUser(id: user.id) else {
            throw UserError.userNotFound
        }

        model.email = user.email
        model.displayName = user.displayName
        model.subscriptionTierRaw = user.subscriptionTier.rawValue
        model.wellnessGoals = user.wellnessGoals
        model.checkInStreak = user.checkInStreak

        try await localDataSource.update(model)
    }

    func updateStreak(userId: String, streak: Int) async throws {
        guard let model = try await localDataSource.getUser(id: userId) else {
            throw UserError.userNotFound
        }

        model.checkInStreak = streak
        try await localDataSource.update(model)
    }

    func updateWellnessGoals(userId: String, goals: [String]) async throws {
        guard let model = try await localDataSource.getUser(id: userId) else {
            throw UserError.userNotFound
        }

        model.wellnessGoals = goals
        try await localDataSource.update(model)
    }

    func updateSubscriptionTier(userId: String, tier: SubscriptionTier) async throws {
        guard let model = try await localDataSource.getUser(id: userId) else {
            throw UserError.userNotFound
        }

        model.subscriptionTierRaw = tier.rawValue
        try await localDataSource.update(model)
    }

    func deleteUser(id: String) async throws {
        try await localDataSource.delete(id: id)
    }

    func completeOnboarding(userId: String) async throws {
        guard let model = try await localDataSource.getUser(id: userId) else {
            throw UserError.userNotFound
        }

        model.hasCompletedOnboarding = true
        try await localDataSource.update(model)
    }

    func hasCompletedOnboarding(userId: String) async throws -> Bool {
        guard let model = try await localDataSource.getUser(id: userId) else {
            return false
        }
        return model.hasCompletedOnboarding
    }
}
