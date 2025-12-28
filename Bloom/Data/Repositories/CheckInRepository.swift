//
//  CheckInRepository.swift
//  Bloom
//
//  Repository implementation for daily check-ins
//

import Foundation

/// Implementation of CheckInRepositoryProtocol
final class CheckInRepository: CheckInRepositoryProtocol, @unchecked Sendable {
    private let localDataSource: LocalCheckInDataSource

    init(localDataSource: LocalCheckInDataSource = LocalCheckInDataSource()) {
        self.localDataSource = localDataSource
    }

    func save(_ checkIn: DailyCheckIn) async throws {
        let model = DailyCheckInModel(from: checkIn)
        try await localDataSource.save(model)
    }

    func getById(_ id: String) async throws -> DailyCheckIn? {
        try await localDataSource.getById(id)?.toDomain()
    }

    func getTodayCheckIn(userId: String) async throws -> DailyCheckIn? {
        try await localDataSource.getTodayCheckIn(userId: userId)?.toDomain()
    }

    func getHistory(userId: String, days: Int) async throws -> [DailyCheckIn] {
        let models = try await localDataSource.getHistory(userId: userId, days: days)
        return models.map { $0.toDomain() }
    }

    func updateInsight(id: String, insight: String) async throws {
        try await localDataSource.updateInsight(id: id, insight: insight)
    }

    func delete(id: String) async throws {
        try await localDataSource.delete(id: id)
    }

    func getStreak(userId: String) async throws -> Int {
        let history = try await localDataSource.getHistory(userId: userId, days: 365)
        return calculateStreak(from: history)
    }

    func getWeeklyStats(userId: String) async throws -> WeeklyCheckInStats {
        let history = try await localDataSource.getHistory(userId: userId, days: 7)

        guard !history.isEmpty else {
            return WeeklyCheckInStats(
                totalCheckIns: 0,
                averageMood: 0,
                averageEnergy: 0,
                averageSleepHours: 0,
                averageSleepQuality: 0,
                moodTrend: .stable,
                energyTrend: .stable
            )
        }

        let totalCheckIns = history.count
        let avgMood = Double(history.reduce(0) { $0 + $1.moodScore }) / Double(totalCheckIns)
        let avgEnergy = Double(history.reduce(0) { $0 + $1.energyScore }) / Double(totalCheckIns)
        let avgSleepHours = history.reduce(0) { $0 + $1.sleepHours } / Double(totalCheckIns)
        let avgSleepQuality = Double(history.reduce(0) { $0 + $1.sleepQuality }) / Double(totalCheckIns)

        // Calculate trends (compare first half to second half of week)
        let midpoint = totalCheckIns / 2
        let firstHalf = Array(history.suffix(from: midpoint))
        let secondHalf = Array(history.prefix(midpoint))

        let moodTrend = calculateTrend(
            firstHalf: firstHalf.map { Double($0.moodScore) },
            secondHalf: secondHalf.map { Double($0.moodScore) }
        )

        let energyTrend = calculateTrend(
            firstHalf: firstHalf.map { Double($0.energyScore) },
            secondHalf: secondHalf.map { Double($0.energyScore) }
        )

        return WeeklyCheckInStats(
            totalCheckIns: totalCheckIns,
            averageMood: avgMood,
            averageEnergy: avgEnergy,
            averageSleepHours: avgSleepHours,
            averageSleepQuality: avgSleepQuality,
            moodTrend: moodTrend,
            energyTrend: energyTrend
        )
    }

    // MARK: - Private Helpers

    private func calculateStreak(from checkIns: [DailyCheckInModel]) -> Int {
        let calendar = Calendar.current
        var streak = 0
        var checkDate = calendar.startOfDay(for: Date())

        while true {
            let hasCheckIn = checkIns.contains {
                calendar.isDate($0.timestamp, inSameDayAs: checkDate)
            }

            if hasCheckIn {
                streak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else {
                break
            }
        }

        return streak
    }

    private func calculateTrend(firstHalf: [Double], secondHalf: [Double]) -> WeeklyCheckInStats.Trend {
        guard !firstHalf.isEmpty && !secondHalf.isEmpty else { return .stable }

        let firstAvg = firstHalf.reduce(0, +) / Double(firstHalf.count)
        let secondAvg = secondHalf.reduce(0, +) / Double(secondHalf.count)

        let difference = secondAvg - firstAvg

        if difference > 0.5 {
            return .improving
        } else if difference < -0.5 {
            return .declining
        } else {
            return .stable
        }
    }
}
