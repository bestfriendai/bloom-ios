//
//  OnboardingView.swift
//  Bloom
//
//  Onboarding flow with wellness goal selection
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var selectedGoals: Set<WellnessGoal> = []
    @State private var navigateToAuth = false

    private let totalPages = 4

    var body: some View {
        NavigationStack {
            ZStack {
                Color.bloomAdaptiveBackground
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    TabView(selection: $currentPage) {
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

                        GoalSelectionScreen(selectedGoals: $selectedGoals)
                            .tag(3)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.bloomSmooth, value: currentPage)

                    VStack(spacing: Spacing.lg) {
                        PageIndicator(currentPage: currentPage, totalPages: totalPages)

                        if currentPage < totalPages - 1 {
                            PrimaryButton(title: "Continue") {
                                withAnimation(.bloomSmooth) {
                                    currentPage += 1
                                }
                            }
                        } else {
                            PrimaryButton(title: "Get Started") {
                                navigateToAuth = true
                            }
                            .disabled(selectedGoals.isEmpty)
                            .opacity(selectedGoals.isEmpty ? 0.5 : 1.0)
                        }

                        if currentPage > 0 {
                            Button(action: {
                                withAnimation(.bloomSmooth) {
                                    currentPage -= 1
                                }
                            }) {
                                Text("Back")
                                    .font(.bloomBodyLarge)
                                    .foregroundColor(.bloomTextSecondary)
                            }
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
    @Binding var selectedGoals: Set<WellnessGoal>

    private let goals: [WellnessGoal] = [
        WellnessGoal(id: "sleep", icon: "moon.stars.fill", title: "Better Sleep", color: .bloomPrimary),
        WellnessGoal(id: "stress", icon: "heart.fill", title: "Reduce Stress", color: .bloomCoral),
        WellnessGoal(id: "energy", icon: "bolt.fill", title: "More Energy", color: .bloomGreen),
        WellnessGoal(id: "mindfulness", icon: "brain.head.profile", title: "Mindfulness", color: .bloomPrimary),
        WellnessGoal(id: "exercise", icon: "figure.walk", title: "Exercise More", color: .bloomCoral),
        WellnessGoal(id: "gratitude", icon: "sparkles", title: "Practice Gratitude", color: .bloomGreen)
    ]

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
                ForEach(goals) { goal in
                    GoalCard(
                        goal: goal,
                        isSelected: selectedGoals.contains(goal)
                    ) {
                        withAnimation(.bloomBouncy) {
                            if selectedGoals.contains(goal) {
                                selectedGoals.remove(goal)
                            } else {
                                selectedGoals.insert(goal)
                            }
                        }
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
        Button(action: action) {
            VStack(spacing: Spacing.sm) {
                ZStack {
                    Circle()
                        .fill(goal.color.opacity(isSelected ? 0.2 : 0.1))
                        .frame(width: 60, height: 60)

                    Image(systemName: goal.icon)
                        .font(.system(size: 28))
                        .foregroundColor(isSelected ? goal.color : .bloomTextSecondary)
                }

                Text(goal.title)
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
        }
        .buttonStyle(PlainButtonStyle())
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

struct WellnessGoal: Identifiable, Hashable {
    let id: String
    let icon: String
    let title: String
    let color: Color
}

#Preview {
    OnboardingView()
}
