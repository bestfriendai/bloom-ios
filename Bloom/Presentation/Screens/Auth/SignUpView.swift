//
//  SignUpView.swift
//  Bloom
//
//  Sign up screen with email/password registration
//

import SwiftUI

struct SignUpView: View {
    @State private var viewModel = AuthViewModel()
    @State private var showTermsOfService = false
    @State private var showPrivacyPolicy = false

    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState

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

                                    Button(action: {
                                        HapticManager.shared.impact(.light)
                                        showTermsOfService = true
                                    }) {
                                        Text("Terms of Service")
                                            .font(.bloomBodySmall)
                                            .foregroundColor(.bloomPrimary)
                                            .underline()
                                    }
                                    .accessibilityLabel("View Terms of Service")
                                }

                                HStack(spacing: 4) {
                                    Text("and")
                                        .font(.bloomBodySmall)
                                        .foregroundColor(.bloomTextSecondary)

                                    Button(action: {
                                        HapticManager.shared.impact(.light)
                                        showPrivacyPolicy = true
                                    }) {
                                        Text("Privacy Policy")
                                            .font(.bloomBodySmall)
                                            .foregroundColor(.bloomPrimary)
                                            .underline()
                                    }
                                    .accessibilityLabel("View Privacy Policy")
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
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $showTermsOfService) {
            TermsOfServiceView()
        }
        .sheet(isPresented: $showPrivacyPolicy) {
            PrivacyPolicyView()
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func handleSignUp() {
        Task {
            await viewModel.signUp()
            if let user = viewModel.currentUser {
                HapticManager.shared.notification(.success)
                appState.currentUser = user
                appState.isAuthenticated = true
            }
        }
    }

    private func handleAppleSignUp() {
        Task {
            await viewModel.signUpWithApple()
            if let user = viewModel.currentUser {
                HapticManager.shared.notification(.success)
                appState.currentUser = user
                appState.isAuthenticated = true
            }
        }
    }

    private func handleGoogleSignUp() {
        Task {
            await viewModel.signUpWithGoogle()
            if let user = viewModel.currentUser {
                HapticManager.shared.notification(.success)
                appState.currentUser = user
                appState.isAuthenticated = true
            }
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
    .environment(AppState())
}

// MARK: - Terms of Service View

struct TermsOfServiceView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Terms of Service")
                        .font(.bloomHeadlineLarge)
                        .foregroundColor(.bloomTextPrimary)

                    Text("Last updated: \(formattedDate)")
                        .font(.bloomBodySmall)
                        .foregroundColor(.bloomTextSecondary)

                    Group {
                        sectionHeader("1. Acceptance of Terms")
                        sectionBody("By accessing and using Bloom, you accept and agree to be bound by the terms and provisions of this agreement.")

                        sectionHeader("2. Description of Service")
                        sectionBody("Bloom is a wellness tracking application that provides AI-powered insights, habit tracking, and daily check-in features to support your wellness journey.")

                        sectionHeader("3. User Responsibilities")
                        sectionBody("You are responsible for maintaining the confidentiality of your account and password. You agree to accept responsibility for all activities that occur under your account.")

                        sectionHeader("4. Privacy")
                        sectionBody("Your privacy is important to us. Please review our Privacy Policy to understand how we collect, use, and protect your personal information.")

                        sectionHeader("5. AI-Generated Content")
                        sectionBody("Bloom uses artificial intelligence to generate wellness insights and recommendations. These are for informational purposes only and should not replace professional medical advice.")

                        sectionHeader("6. Subscription and Payments")
                        sectionBody("Some features require a premium subscription. Subscription fees are billed in advance on a monthly or annual basis. You may cancel your subscription at any time.")

                        sectionHeader("7. Limitation of Liability")
                        sectionBody("Bloom is not a substitute for professional medical, mental health, or therapeutic advice. Always consult with qualified healthcare providers for medical concerns.")

                        sectionHeader("8. Changes to Terms")
                        sectionBody("We reserve the right to modify these terms at any time. We will notify users of significant changes via email or in-app notification.")
                    }
                }
                .padding(Spacing.screenPadding)
            }
            .background(Color.bloomAdaptiveBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.bloomPrimary)
                }
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.bloomTitleMedium)
            .foregroundColor(.bloomTextPrimary)
            .padding(.top, Spacing.sm)
    }

    private func sectionBody(_ text: String) -> some View {
        Text(text)
            .font(.bloomBodyMedium)
            .foregroundColor(.bloomTextSecondary)
            .lineSpacing(4)
    }
}

// MARK: - Privacy Policy View

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.lg) {
                    Text("Privacy Policy")
                        .font(.bloomHeadlineLarge)
                        .foregroundColor(.bloomTextPrimary)

                    Text("Last updated: \(formattedDate)")
                        .font(.bloomBodySmall)
                        .foregroundColor(.bloomTextSecondary)

                    Group {
                        sectionHeader("1. Information We Collect")
                        sectionBody("We collect information you provide directly, including your name, email address, wellness check-in data, and habit tracking information.")

                        sectionHeader("2. How We Use Your Information")
                        sectionBody("Your data is used to provide personalized wellness insights, track your progress, and improve our AI-powered recommendations. We never sell your personal data.")

                        sectionHeader("3. Data Storage and Security")
                        sectionBody("Your data is securely stored using industry-standard encryption. Check-in data is stored locally on your device and synced securely to our cloud servers.")

                        sectionHeader("4. AI Processing")
                        sectionBody("Your wellness data may be processed by AI models to generate personalized insights. This data is anonymized and not used to train AI models.")

                        sectionHeader("5. Third-Party Services")
                        sectionBody("We use secure third-party services for authentication (Apple, Google), analytics, and payment processing. These services have their own privacy policies.")

                        sectionHeader("6. Data Retention")
                        sectionBody("We retain your data for as long as your account is active. You can request deletion of your data at any time through the app settings.")

                        sectionHeader("7. Your Rights")
                        sectionBody("You have the right to access, correct, or delete your personal data. You can export your wellness data at any time through the app.")

                        sectionHeader("8. Children's Privacy")
                        sectionBody("Bloom is not intended for children under 13. We do not knowingly collect personal information from children under 13 years of age.")

                        sectionHeader("9. Contact Us")
                        sectionBody("If you have questions about this Privacy Policy or your data, please contact us at privacy@bloomapp.com.")
                    }
                }
                .padding(Spacing.screenPadding)
            }
            .background(Color.bloomAdaptiveBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.bloomPrimary)
                }
            }
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }

    private func sectionHeader(_ text: String) -> some View {
        Text(text)
            .font(.bloomTitleMedium)
            .foregroundColor(.bloomTextPrimary)
            .padding(.top, Spacing.sm)
    }

    private func sectionBody(_ text: String) -> some View {
        Text(text)
            .font(.bloomBodyMedium)
            .foregroundColor(.bloomTextSecondary)
            .lineSpacing(4)
    }
}
