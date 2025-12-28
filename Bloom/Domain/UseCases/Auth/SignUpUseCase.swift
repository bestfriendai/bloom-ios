//
//  SignUpUseCase.swift
//  Bloom
//
//  Use case for creating new user accounts
//

import Foundation

/// Use case for creating a new user account
final class SignUpUseCase: Sendable {
    private let authRepository: AuthRepositoryProtocol
    private let userRepository: UserRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol, userRepository: UserRepositoryProtocol) {
        self.authRepository = authRepository
        self.userRepository = userRepository
    }

    /// Executes the sign-up operation
    /// - Parameters:
    ///   - name: User's display name
    ///   - email: User's email address
    ///   - password: User's password
    /// - Returns: The newly created user's profile
    func execute(name: String, email: String, password: String) async throws -> UserProfile {
        // Validate input
        guard !name.isEmpty else {
            throw AuthError.invalidCredentials
        }
        guard isValidEmail(email) else {
            throw AuthError.invalidCredentials
        }
        guard isValidPassword(password) else {
            throw AuthError.weakPassword
        }

        // Create account
        let user = try await authRepository.signUp(name: name, email: email, password: password)

        return user
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        guard password.count >= 8 else { return false }
        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil
        return hasUppercase && hasNumber
    }
}
