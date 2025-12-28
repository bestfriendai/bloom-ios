//
//  UserProfileModel.swift
//  Bloom
//
//  SwiftData model for user profile persistence
//

import Foundation
import SwiftData

@Model
final class UserProfileModel {
    @Attribute(.unique) var id: String
    var email: String
    var displayName: String
    var createdAt: Date
    var subscriptionTierRaw: String
    var wellnessGoals: [String]
    var checkInStreak: Int
    var hasCompletedOnboarding: Bool

    init(
        id: String,
        email: String,
        displayName: String,
        createdAt: Date = Date(),
        subscriptionTierRaw: String = "free",
        wellnessGoals: [String] = [],
        checkInStreak: Int = 0,
        hasCompletedOnboarding: Bool = false
    ) {
        self.id = id
        self.email = email
        self.displayName = displayName
        self.createdAt = createdAt
        self.subscriptionTierRaw = subscriptionTierRaw
        self.wellnessGoals = wellnessGoals
        self.checkInStreak = checkInStreak
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }

    var subscriptionTier: SubscriptionTier {
        get { SubscriptionTier(rawValue: subscriptionTierRaw) ?? .free }
        set { subscriptionTierRaw = newValue.rawValue }
    }
}

// MARK: - Domain Conversion

extension UserProfileModel {
    func toDomain() -> UserProfile {
        UserProfile(
            id: id,
            email: email,
            displayName: displayName,
            createdAt: createdAt,
            subscriptionTier: subscriptionTier,
            wellnessGoals: wellnessGoals,
            checkInStreak: checkInStreak
        )
    }

    convenience init(from domain: UserProfile) {
        self.init(
            id: domain.id,
            email: domain.email,
            displayName: domain.displayName,
            createdAt: domain.createdAt,
            subscriptionTierRaw: domain.subscriptionTier.rawValue,
            wellnessGoals: domain.wellnessGoals,
            checkInStreak: domain.checkInStreak
        )
    }
}
