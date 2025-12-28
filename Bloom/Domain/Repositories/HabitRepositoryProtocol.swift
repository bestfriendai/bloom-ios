//
//  HabitRepositoryProtocol.swift
//  Bloom
//
//  Repository protocol for habit tracking operations
//

import Foundation

/// Errors that can occur during habit operations
enum HabitError: Error, LocalizedError {
    case habitNotFound
    case saveFailed
    case maxHabitsReached
    case networkError
    case invalidData

    var errorDescription: String? {
        switch self {
        case .habitNotFound:
            return "Habit not found"
        case .saveFailed:
            return "Failed to save habit"
        case .maxHabitsReached:
            return "Maximum number of habits reached. Upgrade to premium for more."
        case .networkError:
            return "Network error. Please check your connection"
        case .invalidData:
            return "Invalid habit data"
        }
    }
}

/// Protocol defining habit repository operations
protocol HabitRepositoryProtocol: Sendable {
    /// Creates a new habit
    func create(_ habit: Habit) async throws

    /// Retrieves a habit by ID
    func getById(_ id: String) async throws -> Habit?

    /// Retrieves all habits for a user
    func getAll(userId: String) async throws -> [Habit]

    /// Retrieves only active habits for a user
    func getActive(userId: String) async throws -> [Habit]

    /// Updates a habit
    func update(_ habit: Habit) async throws

    /// Marks a habit as completed for a specific date
    func complete(habitId: String, date: Date) async throws

    /// Uncompletes a habit for a specific date
    func uncomplete(habitId: String, date: Date) async throws

    /// Deletes a habit
    func delete(id: String) async throws

    /// Archives a habit (sets isActive to false)
    func archive(id: String) async throws

    /// Gets habit correlations with check-in data
    func getCorrelations(userId: String) async throws -> [HabitCorrelation]
}

/// Represents a correlation between a habit and wellness metrics
struct HabitCorrelation {
    let habitId: String
    let habitName: String
    let moodCorrelation: Double      // -1.0 to 1.0
    let energyCorrelation: Double    // -1.0 to 1.0
    let sleepCorrelation: Double     // -1.0 to 1.0
    let sampleSize: Int

    var summary: String {
        if moodCorrelation > 0.3 {
            return "Your mood is \(Int(moodCorrelation * 100))% higher on days you complete this habit"
        } else if energyCorrelation > 0.3 {
            return "Your energy is \(Int(energyCorrelation * 100))% higher on days you complete this habit"
        } else if sleepCorrelation > 0.3 {
            return "Your sleep quality is \(Int(sleepCorrelation * 100))% better on days you complete this habit"
        }
        return "Keep tracking to discover patterns"
    }
}
