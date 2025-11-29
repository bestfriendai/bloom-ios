//
//  SignUpView.swift
//  Bloom
//
//  Sign up screen with email/password registration
//

import SwiftUI

struct SignUpView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var agreeToTerms = false
    @State private var isLoading = false
    @State private var showPasswordMismatchError = false

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
                            text: $name,
                            icon: "person.fill"
                        )

                        CustomTextField(
                            placeholder: "Email",
                            text: $email,
                            icon: "envelope.fill",
                            keyboardType: .emailAddress,
                            autocapitalization: .never
                        )

                        CustomTextField(
                            placeholder: "Password",
                            text: $password,
                            icon: "lock.fill",
                            isSecure: true
                        )

                        CustomTextField(
                            placeholder: "Confirm Password",
                            text: $confirmPassword,
                            icon: "lock.fill",
                            isSecure: true
                        )

                        if showPasswordMismatchError {
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

                        PasswordRequirements(password: password)
                    }

                    VStack(spacing: Spacing.md) {
                        HStack(spacing: Spacing.sm) {
                            Button(action: { agreeToTerms.toggle() }) {
                                Image(systemName: agreeToTerms ? "checkmark.square.fill" : "square")
                                    .font(.bloomTitleMedium)
                                    .foregroundColor(agreeToTerms ? .bloomPrimary : .bloomTextSecondary)
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
                            isLoading: isLoading
                        )
                        .disabled(!isFormValid)
                        .opacity(isFormValid ? 1.0 : 0.5)

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

    private var isFormValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword &&
        isPasswordValid &&
        agreeToTerms
    }

    private var isPasswordValid: Bool {
        password.count >= 8
    }

    private func handleSignUp() {
        guard password == confirmPassword else {
            showPasswordMismatchError = true
            return
        }

        showPasswordMismatchError = false
        isLoading = true

        // TODO: Implement sign up logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }

    private func handleAppleSignUp() {
        // TODO: Implement Apple Sign Up
    }

    private func handleGoogleSignUp() {
        // TODO: Implement Google Sign Up
    }
}

struct PasswordRequirements: View {
    let password: String

    private var hasMinLength: Bool {
        password.count >= 8
    }

    private var hasUppercase: Bool {
        password.range(of: "[A-Z]", options: .regularExpression) != nil
    }

    private var hasNumber: Bool {
        password.range(of: "[0-9]", options: .regularExpression) != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.xs) {
            Text("Password must contain:")
                .font(.bloomLabelSmall)
                .foregroundColor(.bloomTextSecondary)

            RequirementRow(text: "At least 8 characters", isMet: hasMinLength)
            RequirementRow(text: "One uppercase letter", isMet: hasUppercase)
            RequirementRow(text: "One number", isMet: hasNumber)
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
