//
//  SignInUseCase.swift
//  Bloom
//
//  Use case for signing in users
//

import Foundation

/// Use case for signing in a user with email and password
final class SignInUseCase: Sendable {
    private let authRepository: AuthRepositoryProtocol
    private let userRepository: UserRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }

    /// Executes the sign-in operation
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: The authenticated user's profile
    func execute(email: String, password: String) async throws -> UserProfile {
        // Validate input
        guard !email.isEmpty else {
            throw AuthError.invalidCredentials
        }
        guard !password.isEmpty else {
            throw AuthError.invalidCredentials
        }

        // Perform sign in
        let user = try await authRepository.signIn(email: email, password: password)

        return user
    }
}
