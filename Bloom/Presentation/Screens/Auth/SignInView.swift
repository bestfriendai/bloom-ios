//
//  SignInView.swift
//  Bloom
//
//  Sign in screen with email/password and social auth
//

import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var navigateToSignUp = false

    var body: some View {
        ZStack {
            Color.bloomAdaptiveBackground
                .ignoresSafeArea()

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

                        HStack {
                            Spacer()
                            Button(action: {}) {
                                Text("Forgot Password?")
                                    .font(.bloomBodyMedium)
                                    .foregroundColor(.bloomPrimary)
                            }
                        }
                    }

                    VStack(spacing: Spacing.md) {
                        PrimaryButton(
                            title: "Sign In",
                            action: handleSignIn,
                            isLoading: isLoading
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
    }

    private func handleSignIn() {
        isLoading = true
        // TODO: Implement sign in logic
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
        }
    }

    private func handleAppleSignIn() {
        // TODO: Implement Apple Sign In
    }

    private func handleGoogleSignIn() {
        // TODO: Implement Google Sign In
    }
}

struct SocialSignInButton: View {
    let icon: String
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
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
    }
}

#Preview {
    NavigationStack {
        SignInView()
    }
}
