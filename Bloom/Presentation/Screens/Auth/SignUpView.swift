//
//  SignUpView.swift
//  Bloom
//
//  Sign up screen with email/password registration
//

import SwiftUI

struct SignUpView: View {
    @State private var viewModel = AuthViewModel()

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.bloomAdaptiveBackground
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: Spacing.xl) {
                    Spacer()
                        .frame(height: Spacing.lg)

                    VStack(spacing: Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(Color.bloomPrimary.opacity(0.1))
                                .frame(width: 80, height: 80)

                            Image(systemName: "leaf.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.bloomGradient)
                        }

                        Text("Create Account")
                            .font(.bloomHeadlineLarge)
                            .foregroundColor(.bloomTextPrimary)

                        Text("Start your wellness journey today")
                            .font(.bloomBodyLarge)
                            .foregroundColor(.bloomTextSecondary)
                    }

                    VStack(spacing: Spacing.md) {
                        CustomTextField(
                            placeholder: "Full Name",
                            text: $viewModel.signUpName,
                            icon: "person.fill"
                        )

                        CustomTextField(
                            placeholder: "Email",
                            text: $viewModel.signUpEmail,
                            icon: "envelope.fill",
                            keyboardType: .emailAddress,
                            autocapitalization: .never
                        )

                        CustomTextField(
                            placeholder: "Password",
                            text: $viewModel.signUpPassword,
                            icon: "lock.fill",
                            isSecure: true
                        )

                        CustomTextField(
                            placeholder: "Confirm Password",
                            text: $viewModel.signUpConfirmPassword,
                            icon: "lock.fill",
                            isSecure: true
                        )

                        if viewModel.showPasswordMismatchError {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.bloomBodySmall)
                                Text("Passwords don't match")
                                    .font(.bloomBodySmall)
                                Spacer()
                            }
                            .foregroundColor(.red)
                            .padding(.horizontal, Spacing.xs)
                        }

                        PasswordRequirementsView(requirements: viewModel.passwordRequirements)
                    }

                    if let errorMessage = viewModel.errorMessage {
                        HStack {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.bloomBodySmall)
                            Text(errorMessage)
                                .font(.bloomBodySmall)
                            Spacer()
                        }
                        .foregroundColor(.red)
                        .padding(.horizontal, Spacing.xs)
                    }

                    VStack(spacing: Spacing.md) {
                        HStack(spacing: Spacing.sm) {
                            Button(action: { viewModel.agreeToTerms.toggle() }) {
                                Image(systemName: viewModel.agreeToTerms ? "checkmark.square.fill" : "square")
                                    .font(.bloomTitleMedium)
                                    .foregroundColor(viewModel.agreeToTerms ? .bloomPrimary : .bloomTextSecondary)
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                HStack(spacing: 4) {
                                    Text("I agree to the")
                                        .font(.bloomBodySmall)
                                        .foregroundColor(.bloomTextSecondary)

                                    Button(action: {}) {
                                        Text("Terms of Service")
                                            .font(.bloomBodySmall)
                                            .foregroundColor(.bloomPrimary)
                                            .underline()
                                    }
                                }

                                HStack(spacing: 4) {
                                    Text("and")
                                        .font(.bloomBodySmall)
                                        .foregroundColor(.bloomTextSecondary)

                                    Button(action: {}) {
                                        Text("Privacy Policy")
                                            .font(.bloomBodySmall)
                                            .foregroundColor(.bloomPrimary)
                                            .underline()
                                    }
                                }
                            }

                            Spacer()
                        }

                        PrimaryButton(
                            title: "Create Account",
                            action: handleSignUp,
                            isLoading: viewModel.isSigningUp
                        )
                        .disabled(!viewModel.isSignUpFormValid)
                        .opacity(viewModel.isSignUpFormValid ? 1.0 : 0.5)

                        HStack(spacing: Spacing.xs) {
                            Rectangle()
                                .fill(Color.bloomTextSecondary.opacity(0.3))
                                .frame(height: 1)

                            Text("or")
                                .font(.bloomBodyMedium)
                                .foregroundColor(.bloomTextSecondary)

                            Rectangle()
                                .fill(Color.bloomTextSecondary.opacity(0.3))
                                .frame(height: 1)
                        }

                        HStack(spacing: Spacing.md) {
                            SocialSignInButton(
                                icon: "applelogo",
                                title: "Apple",
                                action: handleAppleSignUp
                            )

                            SocialSignInButton(
                                icon: "g.circle.fill",
                                title: "Google",
                                action: handleGoogleSignUp
                            )
                        }
                    }

                    HStack(spacing: Spacing.xxs) {
                        Text("Already have an account?")
                            .font(.bloomBodyMedium)
                            .foregroundColor(.bloomTextSecondary)

                        Button(action: { dismiss() }) {
                            Text("Sign In")
                                .font(.bloomBodyMedium)
                                .fontWeight(.semibold)
                                .foregroundColor(.bloomPrimary)
                        }
                    }

                    Spacer()
                }
                .padding(.horizontal, Spacing.screenPadding)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func handleSignUp() {
        Task {
            await viewModel.signUp()
            // TODO: Navigate to main app when authenticated
        }
    }

    private func handleAppleSignUp() {
        Task {
            await viewModel.signUpWithApple()
            // TODO: Navigate to main app when authenticated
        }
    }

    private func handleGoogleSignUp() {
        Task {
            await viewModel.signUpWithGoogle()
            // TODO: Navigate to main app when authenticated
        }
    }
}

struct PasswordRequirementsView: View {
    let requirements: PasswordRequirements

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Password must contain:")
                .font(.bloomLabelSmall)
                .foregroundColor(.bloomTextSecondary)

            RequirementRow(text: "At least 8 characters", isMet: requirements.hasMinLength)
            RequirementRow(text: "One uppercase letter", isMet: requirements.hasUppercase)
            RequirementRow(text: "One number", isMet: requirements.hasNumber)
        }
        .padding(.horizontal, Spacing.xs)
    }
}

struct RequirementRow: View {
    let text: String
    let isMet: Bool

    var body: some View {
        HStack(spacing: Spacing.xs) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .font(.bloomLabelSmall)
                .foregroundColor(isMet ? .bloomGreen : .bloomTextSecondary.opacity(0.5))

            Text(text)
                .font(.bloomLabelSmall)
                .foregroundColor(isMet ? .bloomTextPrimary : .bloomTextSecondary)
        }
    }
}

#Preview {
    NavigationStack {
        SignUpView()
    }
}
