//
//  LocalHabitDataSource.swift
//  Bloom
//
//  Local data source for habits using SwiftData
//

import Foundation
import SwiftData

/// Protocol for local habit data operations
protocol LocalHabitDataSourceProtocol: Sendable {
    func save(_ habit: HabitModel) async throws
    func getById(_ id: String) async throws -> HabitModel?
    func getAll(userId: String) async throws -> [HabitModel]
    func getActive(userId: String) async throws -> [HabitModel]
    func update(_ habit: HabitModel) async throws
    func delete(id: String) async throws
    func complete(habitId: String, date: Date) async throws
    func uncomplete(habitId: String, date: Date) async throws
}

/// SwiftData implementation of local habit data source
final class LocalHabitDataSource: LocalHabitDataSourceProtocol, @unchecked Sendable {
    private let container: SwiftDataContainer

    init(container: SwiftDataContainer = .shared) {
        self.container = container
    }

    @MainActor
    func save(_ habit: HabitModel) async throws {
        let context = container.mainContext
        context.insert(habit)
        try context.save()
    }

    @MainActor
    func getById(_ id: String) async throws -> HabitModel? {
        let context = container.mainContext
        let predicate = #Predicate<HabitModel> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try context.fetch(descriptor).first
    }

    @MainActor
    func getAll(userId: String) async throws -> [HabitModel] {
        let context = container.mainContext
        let predicate = #Predicate<HabitModel> { $0.userId == userId }
        let descriptor = FetchDescriptor(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        return try context.fetch(descriptor)
    }

    @MainActor
    func getActive(userId: String) async throws -> [HabitModel] {
        let context = container.mainContext
        let predicate = #Predicate<HabitModel> {
            $0.userId == userId && $0.isActive == true
        }
        let descriptor = FetchDescriptor(
            predicate: predicate,
            sortBy: [SortDescriptor(\.createdAt, order: .forward)]
        )
        return try context.fetch(descriptor)
    }

    @MainActor
    func update(_ habit: HabitModel) async throws {
        try container.mainContext.save()
    }

    @MainActor
    func delete(id: String) async throws {
        let context = container.mainContext
        if let habit = try await getById(id) {
            context.delete(habit)
            try context.save()
        }
    }

    @MainActor
    func complete(habitId: String, date: Date) async throws {
        guard let habit = try await getById(habitId) else {
            throw HabitError.habitNotFound
        }

        let calendar = Calendar.current
        let normalizedDate = calendar.startOfDay(for: date)

        // Check if already completed on this date
        let alreadyCompleted = habit.completedDates.contains {
            calendar.isDate($0, inSameDayAs: normalizedDate)
        }

        if !alreadyCompleted {
            habit.completedDates.append(normalizedDate)
            updateStreaks(for: habit)
            try container.mainContext.save()
        }
    }

    @MainActor
    func uncomplete(habitId: String, date: Date) async throws {
        guard let habit = try await getById(habitId) else {
            throw HabitError.habitNotFound
        }

        let calendar = Calendar.current
        habit.completedDates.removeAll {
            calendar.isDate($0, inSameDayAs: date)
        }
        updateStreaks(for: habit)
        try container.mainContext.save()
    }

    private func updateStreaks(for habit: HabitModel) {
        let calendar = Calendar.current
        var currentStreak = 0
        var checkDate = calendar.startOfDay(for: Date())

        // Calculate current streak
        while true {
            let isCompleted = habit.completedDates.contains {
                calendar.isDate($0, inSameDayAs: checkDate)
            }

            if isCompleted {
                currentStreak += 1
                checkDate = calendar.date(byAdding: .day, value: -1, to: checkDate)!
            } else {
                break
            }
        }

        habit.currentStreak = currentStreak
        habit.longestStreak = max(habit.longestStreak, currentStreak)
    }
}
