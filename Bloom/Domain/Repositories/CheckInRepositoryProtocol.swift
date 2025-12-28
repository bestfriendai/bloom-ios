//
//  CheckInRepositoryProtocol.swift
//  Bloom
//
//  Repository protocol for daily check-in operations
//

import Foundation

/// Errors that can occur during check-in operations
enum CheckInError: Error, LocalizedError {
    case checkInNotFound
    case saveFailed
    case networkError
    case invalidData
    case alreadyCheckedInToday

    var errorDescription: String? {
        switch self {
        case .checkInNotFound:
            return "Check-in not found"
        case .saveFailed:
            return "Failed to save check-in"
        case .networkError:
            return "Network error. Please check your connection"
        case .invalidData:
            return "Invalid check-in data"
        case .alreadyCheckedInToday:
            return "You have already checked in today"
        }
    }
}

/// Protocol defining check-in repository operations
protocol CheckInRepositoryProtocol: Sendable {
    /// Saves a new check-in
    func save(_ checkIn: DailyCheckIn) async throws

    /// Retrieves a check-in by ID
    func getById(_ id: String) async throws -> DailyCheckIn?

    /// Retrieves today's check-in for a user
    func getTodayCheckIn(userId: String) async throws -> DailyCheckIn?

    /// Retrieves check-in history for a user
    func getHistory(userId: String, days: Int) async throws -> [DailyCheckIn]

    /// Updates the AI insight for a check-in
    func updateInsight(id: String, insight: String) async throws

    /// Deletes a check-in
    func delete(id: String) async throws

    /// Gets the current check-in streak for a user
    func getStreak(userId: String) async throws -> Int

    /// Gets weekly check-in statistics
    func getWeeklyStats(userId: String) async throws -> WeeklyCheckInStats
}

/// Statistics for a week of check-ins
struct WeeklyCheckInStats {
    let totalCheckIns: Int
    let averageMood: Double
    let averageEnergy: Double
    let averageSleepHours: Double
    let averageSleepQuality: Double
    let moodTrend: Trend
    let energyTrend: Trend

    enum Trend: String {
        case improving
        case stable
        case declining
    }
}
