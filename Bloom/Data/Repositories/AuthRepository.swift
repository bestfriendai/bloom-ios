//
//  AuthRepository.swift
//  Bloom
//
//  Repository implementation for authentication
//

import Foundation

/// Mock implementation of AuthRepositoryProtocol for development
/// Replace with Firebase implementation for production
final class AuthRepository: AuthRepositoryProtocol, @unchecked Sendable {
    private let localDataSource: LocalUserDataSource
    private var currentUserId: String?

    // Mock continuation for auth state stream
    private var authStateContinuation: AsyncStream<UserProfile?>.Continuation?

    init(localDataSource: LocalUserDataSource = LocalUserDataSource()) {
        self.localDataSource = localDataSource
    }

    var authStatePublisher: AsyncStream<UserProfile?> {
        AsyncStream { continuation in
            self.authStateContinuation = continuation
        }
    }

    func signIn(email: String, password: String) async throws -> UserProfile {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000)

        // Mock validation
        guard email.contains("@") else {
            throw AuthError.invalidCredentials
        }

        guard password.count >= 8 else {
            throw AuthError.invalidCredentials
        }

        // Create or retrieve user
        let userId = email.lowercased().replacingOccurrences(of: "@", with: "_")

        if let existingUser = try await localDataSource.getUser(id: userId) {
            currentUserId = userId
            let user = existingUser.toDomain()
            authStateContinuation?.yield(user)
            return user
        }

        // Create new user profile
        let newUser = UserProfile(
            id: userId,
            email: email,
            displayName: email.components(separatedBy: "@").first ?? "User"
        )

        let userModel = UserProfileModel(from: newUser)
        try await localDataSource.save(userModel)

        currentUserId = userId
        authStateContinuation?.yield(newUser)

        return newUser
    }

    func signUp(name: String, email: String, password: String) async throws -> UserProfile {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_500_000_000)

        // Mock validation
        guard !name.isEmpty else {
            throw AuthError.invalidCredentials
        }

        guard email.contains("@") else {
            throw AuthError.invalidCredentials
        }

        guard password.count >= 8 else {
            throw AuthError.weakPassword
        }

        let userId = email.lowercased().replacingOccurrences(of: "@", with: "_")

        // Check if user already exists
        if try await localDataSource.getUser(id: userId) != nil {
            throw AuthError.emailAlreadyInUse
        }

        // Create new user
        let newUser = UserProfile(
            id: userId,
            email: email,
            displayName: name
        )

        let userModel = UserProfileModel(from: newUser)
        try await localDataSource.save(userModel)

        currentUserId = userId
        authStateContinuation?.yield(newUser)

        return newUser
    }

    func signInWithApple() async throws -> UserProfile {
        // Simulate Apple Sign In
        try await Task.sleep(nanoseconds: 1_000_000_000)

        let appleUserId = "apple_user_\(UUID().uuidString.prefix(8))"

        let user = UserProfile(
            id: appleUserId,
            email: "\(appleUserId)@privaterelay.appleid.com",
            displayName: "Apple User"
        )

        let userModel = UserProfileModel(from: user)
        try await localDataSource.save(userModel)

        currentUserId = appleUserId
        authStateContinuation?.yield(user)

        return user
    }

    func signInWithGoogle() async throws -> UserProfile {
        // Simulate Google Sign In
        try await Task.sleep(nanoseconds: 1_000_000_000)

        let googleUserId = "google_user_\(UUID().uuidString.prefix(8))"

        let user = UserProfile(
            id: googleUserId,
            email: "\(googleUserId)@gmail.com",
            displayName: "Google User"
        )

        let userModel = UserProfileModel(from: user)
        try await localDataSource.save(userModel)

        currentUserId = googleUserId
        authStateContinuation?.yield(user)

        return user
    }

    func signOut() async throws {
        currentUserId = nil
        authStateContinuation?.yield(nil)
    }

    func resetPassword(email: String) async throws {
        // Simulate sending reset email
        try await Task.sleep(nanoseconds: 500_000_000)

        guard email.contains("@") else {
            throw AuthError.invalidCredentials
        }

        // In production, this would send an actual email via Firebase
    }

    func getCurrentUser() async -> UserProfile? {
        guard let userId = currentUserId else { return nil }

        do {
            return try await localDataSource.getUser(id: userId)?.toDomain()
        } catch {
            return nil
        }
    }
}
