//
//  HabitRepository.swift
//  Bloom
//
//  Repository implementation for habits
//

import Foundation

/// Implementation of HabitRepositoryProtocol
final class HabitRepository: HabitRepositoryProtocol, @unchecked Sendable {
    private let localDataSource: LocalHabitDataSource
    private let checkInDataSource: LocalCheckInDataSource

    init(
        localDataSource: LocalHabitDataSource = LocalHabitDataSource(),
        checkInDataSource: LocalCheckInDataSource = LocalCheckInDataSource()
    ) {
        self.localDataSource = localDataSource
        self.checkInDataSource = checkInDataSource
    }

    func create(_ habit: Habit) async throws {
        let model = HabitModel(from: habit)
        try await localDataSource.save(model)
    }

    func getById(_ id: String) async throws -> Habit? {
        try await localDataSource.getById(id)?.toDomain()
    }

    func getAll(userId: String) async throws -> [Habit] {
        let models = try await localDataSource.getAll(userId: userId)
        return models.map { $0.toDomain() }
    }

    func getActive(userId: String) async throws -> [Habit] {
        let models = try await localDataSource.getActive(userId: userId)
        return models.map { $0.toDomain() }
    }

    func update(_ habit: Habit) async throws {
        guard let model = try await localDataSource.getById(habit.id) else {
            throw HabitError.habitNotFound
        }

        model.name = habit.name
        model.icon = habit.icon
        model.color = habit.color
        model.isActive = habit.isActive
        model.completedDates = habit.completedDates
        model.currentStreak = habit.currentStreak
        model.longestStreak = habit.longestStreak

        try await localDataSource.update(model)
    }

    func complete(habitId: String, date: Date) async throws {
        try await localDataSource.complete(habitId: habitId, date: date)
    }

    func uncomplete(habitId: String, date: Date) async throws {
        try await localDataSource.uncomplete(habitId: habitId, date: date)
    }

    func delete(id: String) async throws {
        try await localDataSource.delete(id: id)
    }

    func archive(id: String) async throws {
        guard let model = try await localDataSource.getById(id) else {
            throw HabitError.habitNotFound
        }

        model.isActive = false
        try await localDataSource.update(model)
    }

    func getCorrelations(userId: String) async throws -> [HabitCorrelation] {
        let habits = try await localDataSource.getActive(userId: userId)
        let checkIns = try await checkInDataSource.getHistory(userId: userId, days: 30)

        var correlations: [HabitCorrelation] = []

        for habit in habits {
            let correlation = calculateCorrelation(
                habit: habit,
                checkIns: checkIns
            )
            correlations.append(correlation)
        }

        return correlations.sorted { $0.moodCorrelation > $1.moodCorrelation }
    }

    // MARK: - Private Helpers

    private func calculateCorrelation(
        habit: HabitModel,
        checkIns: [DailyCheckInModel]
    ) -> HabitCorrelation {
        let calendar = Calendar.current

        var daysWithHabit: [(mood: Int, energy: Int, sleep: Int)] = []
        var daysWithoutHabit: [(mood: Int, energy: Int, sleep: Int)] = []

        for checkIn in checkIns {
            let checkInDate = calendar.startOfDay(for: checkIn.timestamp)
            let wasCompleted = habit.completedDates.contains {
                calendar.isDate($0, inSameDayAs: checkInDate)
            }

            let data = (
                mood: checkIn.moodScore,
                energy: checkIn.energyScore,
                sleep: checkIn.sleepQuality
            )

            if wasCompleted {
                daysWithHabit.append(data)
            } else {
                daysWithoutHabit.append(data)
            }
        }

        // Calculate correlations
        let moodCorr = calculateCorrelationValue(
            with: daysWithHabit.map { Double($0.mood) },
            without: daysWithoutHabit.map { Double($0.mood) }
        )

        let energyCorr = calculateCorrelationValue(
            with: daysWithHabit.map { Double($0.energy) },
            without: daysWithoutHabit.map { Double($0.energy) }
        )

        let sleepCorr = calculateCorrelationValue(
            with: daysWithHabit.map { Double($0.sleep) },
            without: daysWithoutHabit.map { Double($0.sleep) }
        )

        return HabitCorrelation(
            habitId: habit.id,
            habitName: habit.name,
            moodCorrelation: moodCorr,
            energyCorrelation: energyCorr,
            sleepCorrelation: sleepCorr,
            sampleSize: daysWithHabit.count + daysWithoutHabit.count
        )
    }

    private func calculateCorrelationValue(with: [Double], without: [Double]) -> Double {
        guard !with.isEmpty && !without.isEmpty else { return 0 }

        let avgWith = with.reduce(0, +) / Double(with.count)
        let avgWithout = without.reduce(0, +) / Double(without.count)

        // Simple percentage difference normalized to -1 to 1 range
        let maxScore = 10.0
        let difference = (avgWith - avgWithout) / maxScore

        return min(1.0, max(-1.0, difference))
    }
}
