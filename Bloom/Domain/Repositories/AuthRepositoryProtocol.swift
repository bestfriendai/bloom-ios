//
//  AuthRepositoryProtocol.swift
//  Bloom
//
//  Repository protocol for authentication operations
//

import Foundation

/// Errors that can occur during authentication
enum AuthError: Error, LocalizedError {
    case invalidCredentials
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case userNotFound
    case emailNotVerified
    case tooManyRequests
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .emailAlreadyInUse:
            return "An account with this email already exists"
        case .weakPassword:
            return "Password is too weak. Please use a stronger password"
        case .networkError:
            return "Network error. Please check your connection"
        case .userNotFound:
            return "No account found with this email"
        case .emailNotVerified:
            return "Please verify your email address"
        case .tooManyRequests:
            return "Too many attempts. Please try again later"
        case .unknownError(let message):
            return message
        }
    }
}

/// Protocol defining authentication repository operations
protocol AuthRepositoryProtocol: Sendable {
    /// Signs in a user with email and password
    func signIn(email: String, password: String) async throws -> UserProfile

    /// Creates a new user account with email and password
    func signUp(name: String, email: String, password: String) async throws -> UserProfile

    /// Signs in or signs up with Apple credentials
    func signInWithApple() async throws -> UserProfile

    /// Signs in or signs up with Google credentials
    func signInWithGoogle() async throws -> UserProfile

    /// Signs out the current user
    func signOut() async throws

    /// Sends a password reset email
    func resetPassword(email: String) async throws

    /// Returns the currently authenticated user, if any
    func getCurrentUser() async -> UserProfile?

    /// Observes authentication state changes
    var authStatePublisher: AsyncStream<UserProfile?> { get }
}
