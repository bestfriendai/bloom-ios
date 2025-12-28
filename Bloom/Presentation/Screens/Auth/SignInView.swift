//
//  SignInView.swift
//  Bloom
//
//  Sign in screen with email/password and social auth
//

import SwiftUI

struct SignInView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = AuthViewModel()
    @State private var navigateToSignUp = false
    @State private var showResetPassword = false

    var body: some View {
        ZStack {
            Color.bloomAdaptiveBackground
                .ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                }

            ScrollView {
                VStack(spacing: Spacing.xl) {
                    Spacer()
                        .frame(height: Spacing.xxl)

                    VStack(spacing: Spacing.md) {
                        ZStack {
                            Circle()
                                .fill(Color.bloomPrimary.opacity(0.1))
                                .frame(width: 80, height: 80)

                            Image(systemName: "leaf.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(Color.bloomGradient)
                        }

                        Text("Welcome Back")
                            .font(.bloomHeadlineLarge)
                            .foregroundColor(.bloomTextPrimary)

                        Text("Continue your wellness journey")
                            .font(.bloomBodyLarge)
                            .foregroundColor(.bloomTextSecondary)
                    }

                    VStack(spacing: Spacing.md) {
                        CustomTextField(
                            placeholder: "Email",
                            text: $viewModel.signInEmail,
                            icon: "envelope.fill",
                            keyboardType: .emailAddress,
                            autocapitalization: .never
                        )

                        CustomTextField(
                            placeholder: "Password",
                            text: $viewModel.signInPassword,
                            icon: "lock.fill",
                            isSecure: true
                        )

                        HStack {
                            Spacer()
                            Button(action: { showResetPassword = true }) {
                                Text("Forgot Password?")
                                    .font(.bloomBodyMedium)
                                    .foregroundColor(.bloomPrimary)
                            }
                        }
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
                        PrimaryButton(
                            title: "Sign In",
                            action: handleSignIn,
                            isLoading: viewModel.isSigningIn
                        )

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
                                action: handleAppleSignIn
                            )

                            SocialSignInButton(
                                icon: "g.circle.fill",
                                title: "Google",
                                action: handleGoogleSignIn
                            )
                        }
                    }

                    HStack(spacing: Spacing.xxs) {
                        Text("Don't have an account?")
                            .font(.bloomBodyMedium)
                            .foregroundColor(.bloomTextSecondary)

                        Button(action: { navigateToSignUp = true }) {
                            Text("Sign Up")
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
        .navigationBarHidden(false)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $navigateToSignUp) {
            SignUpView()
        }
        .alert("Reset Password", isPresented: $showResetPassword) {
            TextField("Email", text: $viewModel.signInEmail)
            Button("Cancel", role: .cancel) { }
            Button("Send Reset Link") {
                Task {
                    await viewModel.resetPassword(email: viewModel.signInEmail)
                }
            }
        } message: {
            Text("Enter your email to receive a password reset link")
        }
    }

    private func handleSignIn() {
        hideKeyboard()
        Task {
            await viewModel.signIn()
            if viewModel.isAuthenticated, let user = viewModel.currentUser {
                HapticManager.shared.success()
                appState.signIn(user: user)
            }
        }
    }

    private func handleAppleSignIn() {
        Task {
            await viewModel.signInWithApple()
            if viewModel.isAuthenticated, let user = viewModel.currentUser {
                HapticManager.shared.success()
                appState.signIn(user: user)
            }
        }
    }

    private func handleGoogleSignIn() {
        Task {
            await viewModel.signInWithGoogle()
            if viewModel.isAuthenticated, let user = viewModel.currentUser {
                HapticManager.shared.success()
                appState.signIn(user: user)
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

struct SocialSignInButton: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button {
            HapticManager.shared.buttonTap()
            action()
        } label: {
            HStack(spacing: Spacing.xs) {
                Image(systemName: icon)
                    .font(.bloomTitleMedium)

                Text(title)
                    .font(.bloomBodyMedium)
                    .fontWeight(.medium)
            }
            .foregroundColor(.bloomTextPrimary)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.bloomCard)
            .cornerRadius(Spacing.cornerRadiusSmall)
            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(ScaleButtonStyle())
        .accessibilityLabel("Sign in with \(title)")
        .accessibilityHint("Double tap to sign in using your \(title) account")
    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
}
