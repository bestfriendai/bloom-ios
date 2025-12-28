//
//  OnboardingView.swift
//  Bloom
//
//  Onboarding flow with wellness goal selection
//

import SwiftUI

struct OnboardingView: View {
    @Environment(AppState.self) private var appState
    @State private var viewModel = OnboardingViewModel()
    @State private var navigateToAuth = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bloomAdaptiveBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    TabView(selection: $viewModel.currentPage) {
                        WelcomeScreen()
                            .tag(0)

                        FeatureScreen(
                            icon: "brain.head.profile",
                            title: "AI-Powered Insights",
                            description: "Get personalized wellness recommendations based on your daily check-ins and patterns"
                        )
                        .tag(1)

                        FeatureScreen(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Track Your Progress",
                            description: "Build healthy habits and see how they correlate with your mood and energy levels"
                        )
                        .tag(2)

                        GoalSelectionScreen(viewModel: viewModel)
                            .tag(3)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.bloomSmooth, value: viewModel.currentPage)

                    VStack(spacing: Spacing.lg) {
                        PageIndicator(currentPage: viewModel.currentPage, totalPages: viewModel.totalPages)

                        if !viewModel.isLastPage {
                            PrimaryButton(title: "Continue") {
                                viewModel.nextPage()
                            }
                        } else {
                            PrimaryButton(title: "Get Started") {
                                Task {
                                    await viewModel.completeOnboarding()
                                    HapticManager.shared.success()
                                    appState.completeOnboarding()
                                    navigateToAuth = true
                                }
                            }
                            .disabled(!viewModel.isGetStartedEnabled)
                            .opacity(viewModel.isGetStartedEnabled ? 1.0 : 0.5)
                        }

                        if !viewModel.isFirstPage {
                            Button {
                                HapticManager.shared.buttonTap()
                                viewModel.previousPage()
                            } label: {
                                Text("Back")
                                    .font(.bloomBodyLarge)
                                    .foregroundColor(.bloomTextSecondary)
                            }
                            .accessibilityLabel("Go back")
                            .accessibilityHint("Returns to the previous screen")
                        }
                    }
                    .padding(.horizontal, Spacing.screenPadding)
                    .padding(.bottom, Spacing.lg)
                }
            }
            .navigationDestination(isPresented: $navigateToAuth) {
                SignInView()
            }
        }
    }
}

struct WelcomeScreen: View {
    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            VStack(spacing: Spacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.bloomPrimary.opacity(0.1))
                        .frame(width: 120, height: 120)

                    Image(systemName: "leaf.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Color.bloomGradient)
                }

                Text("Bloom")
                    .font(.bloomDisplayMedium)
                    .foregroundColor(.bloomTextPrimary)

                Text("Your AI Wellness Coach")
                    .font(.bloomTitleLarge)
                    .foregroundColor(.bloomTextSecondary)
            }

            Spacer()

            VStack(alignment: .leading, spacing: Spacing.md) {
                FeatureRow(icon: "checkmark.circle.fill", text: "Daily check-ins")
                FeatureRow(icon: "sparkles", text: "AI-powered insights")
                FeatureRow(icon: "chart.bar.fill", text: "Habit tracking")
                FeatureRow(icon: "brain.head.profile", text: "Personalized coaching")
            }
            .padding(.horizontal, Spacing.xl)

            Spacer()
        }
        .padding(.horizontal, Spacing.screenPadding)
    }
}

struct FeatureScreen: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.bloomPrimary.opacity(0.1))
                    .frame(width: 140, height: 140)

                Image(systemName: icon)
                    .font(.system(size: 70))
                    .foregroundStyle(Color.bloomGradient)
            }

            VStack(spacing: Spacing.md) {
                Text(title)
                    .font(.bloomHeadlineLarge)
                    .foregroundColor(.bloomTextPrimary)
                    .multilineTextAlignment(.center)

                Text(description)
                    .font(.bloomBodyLarge)
                    .foregroundColor(.bloomTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, Spacing.xl)

            Spacer()
        }
        .padding(.horizontal, Spacing.screenPadding)
    }
}

struct GoalSelectionScreen: View {
    let viewModel: OnboardingViewModel

    var body: some View {
        VStack(spacing: Spacing.xl) {
            VStack(spacing: Spacing.sm) {
                Text("What are your goals?")
                    .font(.bloomHeadlineLarge)
                    .foregroundColor(.bloomTextPrimary)
                    .multilineTextAlignment(.center)

                Text("Select all that apply")
                    .font(.bloomBodyLarge)
                    .foregroundColor(.bloomTextSecondary)
            }
            .padding(.top, Spacing.xl)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.md) {
                ForEach(viewModel.availableGoals) { goal in
                    GoalCard(
                        goal: goal,
                        isSelected: viewModel.isGoalSelected(goal)
                    ) {
                        viewModel.toggleGoal(goal)
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, Spacing.screenPadding)
    }
}

struct GoalCard: View {
    let goal: WellnessGoal
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button {
            HapticManager.shared.selection()
            action()
        } label: {
            VStack(spacing: Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(goal.color.opacity(isSelected ? 0.2 : 0.1))
                        .frame(width: 60, height: 60)

                    Image(systemName: goal.type.icon)
                        .font(.system(size: 28))
                        .foregroundColor(isSelected ? goal.color : .bloomTextSecondary)
                }

                Text(goal.type.rawValue)
                    .font(.bloomBodyMedium)
                    .foregroundColor(isSelected ? .bloomTextPrimary : .bloomTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, Spacing.md)
            .background(isSelected ? Color.bloomCard : Color.bloomCard.opacity(0.5))
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.cornerRadius)
                    .stroke(isSelected ? goal.color : Color.clear, lineWidth: 2)
            )
            .cornerRadius(Spacing.cornerRadius)
            .shadow(color: Color.black.opacity(isSelected ? 0.1 : 0.05), radius: isSelected ? 12 : 8, x: 0, y: 4)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.bloomBouncy, value: isSelected)
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(goal.type.rawValue)
        .accessibilityValue(isSelected ? "Selected" : "Not selected")
        .accessibilityHint("Double tap to \(isSelected ? "deselect" : "select") this wellness goal")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: Spacing.md) {
            Image(systemName: icon)
                .font(.bloomTitleMedium)
                .foregroundColor(.bloomPrimary)
                .frame(width: 24)

            Text(text)
                .font(.bloomBodyLarge)
                .foregroundColor(.bloomTextPrimary)

            Spacer()
        }
    }
}

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int

    var body: some View {
        HStack(spacing: Spacing.xs) {
            ForEach(0..<totalPages, id: \.self) { index in
                Capsule()
                    .fill(index == currentPage ? Color.bloomPrimary : Color.bloomTextSecondary.opacity(0.3))
                    .frame(width: index == currentPage ? 24 : 8, height: 8)
                    .animation(.bloomSmooth, value: currentPage)
            }
        }
    }
}

#Preview {
    OnboardingView()
}
