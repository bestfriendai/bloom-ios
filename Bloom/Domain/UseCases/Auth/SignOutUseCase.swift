//
//  SignOutUseCase.swift
//  Bloom
//
//  Use case for signing out users
//

import Foundation

/// Use case for signing out the current user
final class SignOutUseCase: Sendable {
    private let authRepository: AuthRepositoryProtocol

    init(authRepository: AuthRepositoryProtocol) {
        self.authRepository = authRepository
    }

    /// Executes the sign-out operation
    func execute() async throws {
        try await authRepository.signOut()
    }
}
