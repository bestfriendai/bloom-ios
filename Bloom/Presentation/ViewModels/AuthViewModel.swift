//
//  AuthViewModel.swift
//  Bloom
//
//  ViewModel for authentication flows (sign in, sign up, social auth)
//

import SwiftUI
import Combine

@Observable
final class AuthViewModel {
    // MARK: - Published State

    // Sign In State
    var signInEmail = ""
    var signInPassword = ""
    var isSigningIn = false

    // Sign Up State
    var signUpName = ""
    var signUpEmail = ""
    var signUpPassword = ""
    var signUpConfirmPassword = ""
    var agreeToTerms = false
    var isSigningUp = false

    // Common State
    var errorMessage: String?
    var isAuthenticated = false
    var currentUser: UserProfile?

    // Validation State
    var showPasswordMismatchError = false

    // MARK: - Use Cases (to be injected)
    // private let signInUseCase: SignInUseCase
    // private let signUpUseCase: SignUpUseCase
    // private let signInWithAppleUseCase: SignInWithAppleUseCase
    // private let signInWithGoogleUseCase: SignInWithGoogleUseCase
    // private let signOutUseCase: SignOutUseCase
    // private let resetPasswordUseCase: ResetPasswordUseCase

    // MARK: - Initialization

    init(
        // signInUseCase: SignInUseCase,
        // signUpUseCase: SignUpUseCase,
        // signInWithAppleUseCase: SignInWithAppleUseCase,
        // signInWithGoogleUseCase: SignInWithGoogleUseCase,
        // signOutUseCase: SignOutUseCase,
        // resetPasswordUseCase: ResetPasswordUseCase
    ) {
        // self.signInUseCase = signInUseCase
        // self.signUpUseCase = signUpUseCase
        // self.signInWithAppleUseCase = signInWithAppleUseCase
        // self.signInWithGoogleUseCase = signInWithGoogleUseCase
        // self.signOutUseCase = signOutUseCase
        // self.resetPasswordUseCase = resetPasswordUseCase
    }

    // MARK: - Sign In Methods

    /// Signs in user with email and password
    /// Calls: SignInUseCase
    @MainActor
    func signIn() async {
        guard validateSignInForm() else { return }

        isSigningIn = true
        errorMessage = nil

        do {
            // TODO: Call SignInUseCase
            // let user = try await signInUseCase.execute(
            //     email: signInEmail,
            //     password: signInPassword
            // )

            // Simulate API call
            try await Task.sleep(nanoseconds: 2_000_000_000)

            // currentUser = user
            isAuthenticated = true
            clearSignInForm()

        } catch {
            errorMessage = error.localizedDescription
        }

        isSigningIn = false
    }

    /// Signs in user with Apple
    /// Calls: SignInWithAppleUseCase
    @MainActor
    func signInWithApple() async {
        errorMessage = nil

        do {
            // TODO: Call SignInWithAppleUseCase
            // let user = try await signInWithAppleUseCase.execute()

            // Simulate API call
            try await Task.sleep(nanoseconds: 1_000_000_000)

            // currentUser = user
            isAuthenticated = true

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Signs in user with Google
    /// Calls: SignInWithGoogleUseCase
    @MainActor
    func signInWithGoogle() async {
        errorMessage = nil

        do {
            // TODO: Call SignInWithGoogleUseCase
            // let user = try await signInWithGoogleUseCase.execute()

            // Simulate API call
            try await Task.sleep(nanoseconds: 1_000_000_000)

            // currentUser = user
            isAuthenticated = true

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Sign Up Methods

    /// Creates new user account with email and password
    /// Calls: SignUpUseCase
    @MainActor
    func signUp() async {
        guard validateSignUpForm() else { return }

        isSigningUp = true
        errorMessage = nil
        showPasswordMismatchError = false

        do {
            // TODO: Call SignUpUseCase
            // let user = try await signUpUseCase.execute(
            //     name: signUpName,
            //     email: signUpEmail,
            //     password: signUpPassword
            // )

            // Simulate API call
            try await Task.sleep(nanoseconds: 2_000_000_000)

            // currentUser = user
            isAuthenticated = true
            clearSignUpForm()

        } catch {
            errorMessage = error.localizedDescription
        }

        isSigningUp = false
    }

    /// Signs up user with Apple
    /// Calls: SignInWithAppleUseCase (same use case, handles both sign in and sign up)
    @MainActor
    func signUpWithApple() async {
        await signInWithApple()
    }

    /// Signs up user with Google
    /// Calls: SignInWithGoogleUseCase (same use case, handles both sign in and sign up)
    @MainActor
    func signUpWithGoogle() async {
        await signInWithGoogle()
    }

    // MARK: - Password Reset

    /// Sends password reset email to user
    /// Calls: ResetPasswordUseCase
    @MainActor
    func resetPassword(email: String) async {
        errorMessage = nil

        guard !email.isEmpty, isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return
        }

        do {
            // TODO: Call ResetPasswordUseCase
            // try await resetPasswordUseCase.execute(email: email)

            // Simulate API call
            try await Task.sleep(nanoseconds: 1_000_000_000)

            // Success - show confirmation to user

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Sign Out

    /// Signs out current user
    /// Calls: SignOutUseCase
    @MainActor
    func signOut() async {
        do {
            // TODO: Call SignOutUseCase
            // try await signOutUseCase.execute()

            isAuthenticated = false
            currentUser = nil
            clearAllForms()

        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Validation

    private func validateSignInForm() -> Bool {
        guard !signInEmail.isEmpty else {
            errorMessage = "Please enter your email"
            return false
        }

        guard isValidEmail(signInEmail) else {
            errorMessage = "Please enter a valid email address"
            return false
        }

        guard !signInPassword.isEmpty else {
            errorMessage = "Please enter your password"
            return false
        }

        return true
    }

    private func validateSignUpForm() -> Bool {
        guard !signUpName.isEmpty else {
            errorMessage = "Please enter your name"
            return false
        }

        guard !signUpEmail.isEmpty else {
            errorMessage = "Please enter your email"
            return false
        }

        guard isValidEmail(signUpEmail) else {
            errorMessage = "Please enter a valid email address"
            return false
        }

        guard !signUpPassword.isEmpty else {
            errorMessage = "Please enter a password"
            return false
        }

        guard isValidPassword(signUpPassword) else {
            errorMessage = "Password must be at least 8 characters with one uppercase letter and one number"
            return false
        }

        guard signUpPassword == signUpConfirmPassword else {
            showPasswordMismatchError = true
            errorMessage = "Passwords don't match"
            return false
        }

        guard agreeToTerms else {
            errorMessage = "Please agree to the Terms of Service and Privacy Policy"
            return false
        }

        return true
    }

    // MARK: - Computed Properties

    var isSignUpFormValid: Bool {
        !signUpName.isEmpty &&
        !signUpEmail.isEmpty &&
        isValidEmail(signUpEmail) &&
        !signUpPassword.isEmpty &&
        isValidPassword(signUpPassword) &&
        signUpPassword == signUpConfirmPassword &&
        agreeToTerms
    }

    var passwordRequirements: PasswordRequirements {
        PasswordRequirements(password: signUpPassword)
    }

    // MARK: - Helper Methods

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    private func isValidPassword(_ password: String) -> Bool {
        // At least 8 characters, one uppercase, one number
        guard password.count >= 8 else { return false }

        let hasUppercase = password.range(of: "[A-Z]", options: .regularExpression) != nil
        let hasNumber = password.range(of: "[0-9]", options: .regularExpression) != nil

        return hasUppercase && hasNumber
    }

    private func clearSignInForm() {
        signInEmail = ""
        signInPassword = ""
    }

    private func clearSignUpForm() {
        signUpName = ""
        signUpEmail = ""
        signUpPassword = ""
        signUpConfirmPassword = ""
        agreeToTerms = false
        showPasswordMismatchError = false
    }

    private func clearAllForms() {
        clearSignInForm()
        clearSignUpForm()
        errorMessage = nil
    }

    /// Clears error message
    func clearError() {
        errorMessage = nil
        showPasswordMismatchError = false
    }
}

// MARK: - Supporting Types

struct PasswordRequirements {
    let password: String

    var hasMinLength: Bool {
        password.count >= 8
    }

    var hasUppercase: Bool {
        password.range(of: "[A-Z]", options: .regularExpression) != nil
    }

    var hasNumber: Bool {
        password.range(of: "[0-9]", options: .regularExpression) != nil
    }

    var isValid: Bool {
        hasMinLength && hasUppercase && hasNumber
    }
}

// Placeholder for UserProfile entity (will be defined in Domain layer)
struct UserProfile: Identifiable {
    let id: String
    let email: String
    let displayName: String
}
