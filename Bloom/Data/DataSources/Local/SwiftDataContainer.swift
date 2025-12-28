//
//  SwiftDataContainer.swift
//  Bloom
//
//  SwiftData container configuration
//

import Foundation
import SwiftData

/// Manages the SwiftData model container for the app
@MainActor
final class SwiftDataContainer {
    static let shared = SwiftDataContainer()

    let container: ModelContainer

    private init() {
        let schema = Schema([
            UserProfileModel.self,
            DailyCheckInModel.self,
            HabitModel.self,
            WellnessGoalModel.self,
            AIInsightCacheModel.self,
            AIInsightUsageModel.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false,
            cloudKitDatabase: .none // Can enable for CloudKit sync later
        )

        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    var mainContext: ModelContext {
        container.mainContext
    }

    /// Creates a new background context for async operations
    func newBackgroundContext() -> ModelContext {
        ModelContext(container)
    }
}
