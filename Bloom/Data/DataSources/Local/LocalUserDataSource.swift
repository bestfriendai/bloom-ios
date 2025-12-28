//
//  LocalUserDataSource.swift
//  Bloom
//
//  Local data source for user profile using SwiftData
//

import Foundation
import SwiftData

/// Protocol for local user data operations
protocol LocalUserDataSourceProtocol: Sendable {
    func save(_ user: UserProfileModel) async throws
    func getUser(id: String) async throws -> UserProfileModel?
    func update(_ user: UserProfileModel) async throws
    func delete(id: String) async throws
    func getCurrentUser() async throws -> UserProfileModel?
}

/// SwiftData implementation of local user data source
final class LocalUserDataSource: LocalUserDataSourceProtocol, @unchecked Sendable {
    private let container: SwiftDataContainer

    init(container: SwiftDataContainer = .shared) {
        self.container = container
    }

    @MainActor
    func save(_ user: UserProfileModel) async throws {
        let context = container.mainContext
        context.insert(user)
        try context.save()
    }

    @MainActor
    func getUser(id: String) async throws -> UserProfileModel? {
        let context = container.mainContext
        let predicate = #Predicate<UserProfileModel> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)
        return try context.fetch(descriptor).first
    }

    @MainActor
    func update(_ user: UserProfileModel) async throws {
        let context = container.mainContext
        try context.save()
    }

    @MainActor
    func delete(id: String) async throws {
        let context = container.mainContext
        if let user = try await getUser(id: id) {
            context.delete(user)
            try context.save()
        }
    }

    @MainActor
    func getCurrentUser() async throws -> UserProfileModel? {
        let context = container.mainContext
        let descriptor = FetchDescriptor<UserProfileModel>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor).first
    }
}
