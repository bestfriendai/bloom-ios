//
//  LocalCheckInDataSource.swift
//  Bloom
//
//  Local data source for check-ins using SwiftData
//

import Foundation
import SwiftData

/// Protocol for local check-in data operations
protocol LocalCheckInDataSourceProtocol: Sendable {
    func save(_ checkIn: DailyCheckInModel) async throws
    func getById(_ id: String) async throws -> DailyCheckInModel?
    func getTodayCheckIn(userId: String) async throws -> DailyCheckInModel?
    func getHistory(userId: String, days: Int) async throws -> [DailyCheckInModel]
    func updateInsight(id: String, insight: String) async throws
    func delete(id: String) async throws
    func getUnsyncedCheckIns() async throws -> [DailyCheckInModel]
    func markAsSynced(id: String) async throws
}

/// SwiftData implementation of local check-in data source
final class LocalCheckInDataSource: LocalCheckInDataSourceProtocol, @unchecked Sendable {
    private let container: SwiftDataContainer

    init(container: SwiftDataContainer = .shared) {
        self.container = container
    }

    @MainActor
    func save(_ checkIn: DailyCheckInModel) async throws {
        let context = container.mainContext
        context.insert(checkIn)
        try context.save()
    }

    @MainActor
    func getById(_ id: String) async throws -> DailyCheckInModel? {
        let context = container.mainContext
        let predicate = #Predicate<DailyCheckInModel> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try context.fetch(descriptor).first
    }

    @MainActor
    func getTodayCheckIn(userId: String) async throws -> DailyCheckInModel? {
        let context = container.mainContext
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!

        let predicate = #Predicate<DailyCheckInModel> {
            $0.userId == userId &&
            $0.timestamp >= startOfDay &&
            $0.timestamp < endOfDay
        }

        let descriptor = FetchDescriptor(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        return try context.fetch(descriptor).first
    }

    @MainActor
    func getHistory(userId: String, days: Int) async throws -> [DailyCheckInModel] {
        let context = container.mainContext
        let startDate = Calendar.current.date(byAdding: .day, value: -days, to: Date())!

        let predicate = #Predicate<DailyCheckInModel> {
            $0.userId == userId && $0.timestamp >= startDate
        }

        let descriptor = FetchDescriptor(
            predicate: predicate,
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )

        return try context.fetch(descriptor)
    }

    @MainActor
    func updateInsight(id: String, insight: String) async throws {
        if let checkIn = try await getById(id) {
            checkIn.aiInsight = insight
            try container.mainContext.save()
        }
    }

    @MainActor
    func delete(id: String) async throws {
        let context = container.mainContext
        if let checkIn = try await getById(id) {
            context.delete(checkIn)
            try context.save()
        }
    }

    @MainActor
    func getUnsyncedCheckIns() async throws -> [DailyCheckInModel] {
        let context = container.mainContext
        let predicate = #Predicate<DailyCheckInModel> { $0.isSynced == false }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try context.fetch(descriptor)
    }

    @MainActor
    func markAsSynced(id: String) async throws {
        if let checkIn = try await getById(id) {
            checkIn.isSynced = true
            try container.mainContext.save()
        }
    }
}
