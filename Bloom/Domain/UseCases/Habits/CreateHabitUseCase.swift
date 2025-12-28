//
//  CreateHabitUseCase.swift
//  Bloom
//
//  Use case for creating new habits
//

import Foundation

/// Use case for creating a new habit
final class CreateHabitUseCase: Sendable {
    private let habitRepository: HabitRepositoryProtocol
    private let userRepository: UserRepositoryProtocol

    init(habitRepository: HabitRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.habitRepository = habitRepository
        self.userRepository = userRepository
    }

    /// Executes the habit creation
    /// - Parameters:
    ///   - habit: The habit to create
    ///   - userId: The user's ID
    /// - Returns: The created habit
    func execute(habit: Habit, userId: String) async throws -> Habit {
        // Get user to check subscription tier
        let user = try await userRepository.getUser(id: userId)

        // Check habit limit based on subscription
        let activeHabits = try await habitRepository.getActive(userId: userId)
        if activeHabits.count >= user.subscriptionTier.maxHabits {
            throw HabitError.maxHabitsReached
        }

        // Create the habit
        try await habitRepository.create(habit)

        return habit
    }

    /// Creates a habit from a template
    /// - Parameters:
    ///   - template: The habit template to use
    ///   - userId: The user's ID
    /// - Returns: The created habit
    func execute(fromTemplate template: HabitTemplate, userId: String) async throws -> Habit {
        let habit = Habit(
            userId: userId,
            name: template.rawValue,
            icon: template.icon,
            color: template.defaultColor
        )

        return try await execute(habit: habit, userId: userId)
    }
}
