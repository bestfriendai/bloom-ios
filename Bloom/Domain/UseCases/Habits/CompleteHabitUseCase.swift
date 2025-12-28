//
//  CompleteHabitUseCase.swift
//  Bloom
//
//  Use case for completing habits
//

import Foundation

/// Use case for marking a habit as completed
final class CompleteHabitUseCase: Sendable {
    private let habitRepository: HabitRepositoryProtocol

    init(habitRepository: HabitRepositoryProtocol) {
        self.habitRepository = habitRepository
    }

    /// Executes the habit completion
    /// - Parameters:
    ///   - habitId: The ID of the habit to complete
    ///   - date: The date to mark as completed (defaults to today)
    func execute(habitId: String, date: Date = Date()) async throws {
        try await habitRepository.complete(habitId: habitId, date: date)
    }

    /// Toggles the completion state of a habit for a date
    /// - Parameters:
    ///   - habit: The habit to toggle
    ///   - date: The date to toggle (defaults to today)
    func toggle(habit: Habit, date: Date = Date()) async throws {
        if habit.isCompleted(on: date) {
            try await habitRepository.uncomplete(habitId: habit.id, date: date)
        } else {
            try await habitRepository.complete(habitId: habit.id, date: date)
        }
    }
}
