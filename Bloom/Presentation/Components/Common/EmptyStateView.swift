//
//  EmptyStateView.swift
//  Bloom
//
//  Reusable empty state views for various screens
//

import SwiftUI

// MARK: - Generic Empty State

struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.bloomPrimary.opacity(0.1))
                    .frame(width: 100, height: 100)

                Image(systemName: icon)
                    .font(.system(size: 44))
                    .foregroundStyle(Color.bloomGradient)
            }
            .accessibilityHidden(true)

            VStack(spacing: Spacing.sm) {
                Text(title)
                    .font(.bloomTitleLarge)
                    .foregroundColor(.bloomTextPrimary)
                    .multilineTextAlignment(.center)

                Text(message)
                    .font(.bloomBodyMedium)
                    .foregroundColor(.bloomTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, Spacing.xl)

            if let actionTitle = actionTitle, let action = action {
                Button(action: {
                    HapticManager.shared.impact(.medium)
                    action()
                }) {
                    Text(actionTitle)
                        .font(.bloomBodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, Spacing.xl)
                        .padding(.vertical, Spacing.md)
                        .background(
                            Capsule()
                                .fill(Color.bloomGradient)
                        )
                }
                .accessibilityLabel(actionTitle)
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Pre-built Empty States

struct NoCheckInsEmptyState: View {
    let onStartCheckIn: () -> Void

    var body: some View {
        EmptyStateView(
            icon: "sun.and.horizon.fill",
            title: "Start Your Day Right",
            message: "Complete your first check-in to begin tracking your wellness journey and receive personalized insights.",
            actionTitle: "Start Check-In",
            action: onStartCheckIn
        )
    }
}

struct NoHabitsEmptyState: View {
    let onCreateHabit: () -> Void

    var body: some View {
        EmptyStateView(
            icon: "checkmark.circle.badge.plus",
            title: "Build Better Habits",
            message: "Create your first habit to start tracking your daily progress and see how it affects your mood.",
            actionTitle: "Create Habit",
            action: onCreateHabit
        )
    }
}

struct NoInsightsEmptyState: View {
    var body: some View {
        EmptyStateView(
            icon: "sparkles",
            title: "Insights Coming Soon",
            message: "Complete a few more check-ins and we'll generate personalized wellness insights just for you."
        )
    }
}

struct NoHistoryEmptyState: View {
    var body: some View {
        EmptyStateView(
            icon: "calendar",
            title: "No History Yet",
            message: "Your check-in history will appear here. Start tracking today to see your progress over time."
        )
    }
}

struct NoSearchResultsEmptyState: View {
    let searchQuery: String

    var body: some View {
        EmptyStateView(
            icon: "magnifyingglass",
            title: "No Results Found",
            message: "We couldn't find anything matching \"\(searchQuery)\". Try a different search term."
        )
    }
}

struct NetworkErrorEmptyState: View {
    let onRetry: () -> Void

    var body: some View {
        EmptyStateView(
            icon: "wifi.slash",
            title: "Connection Issue",
            message: "We're having trouble connecting. Check your internet connection and try again.",
            actionTitle: "Try Again",
            action: onRetry
        )
    }
}

struct GenericErrorEmptyState: View {
    let message: String
    let onRetry: (() -> Void)?

    init(message: String = "Something went wrong. Please try again.", onRetry: (() -> Void)? = nil) {
        self.message = message
        self.onRetry = onRetry
    }

    var body: some View {
        EmptyStateView(
            icon: "exclamationmark.triangle",
            title: "Oops!",
            message: message,
            actionTitle: onRetry != nil ? "Try Again" : nil,
            action: onRetry
        )
    }
}

struct NoCorrelationsEmptyState: View {
    var body: some View {
        EmptyStateView(
            icon: "chart.line.uptrend.xyaxis",
            title: "Not Enough Data",
            message: "Complete habits alongside your check-ins for at least a week to see correlation insights."
        )
    }
}

struct NoChatMessagesEmptyState: View {
    var body: some View {
        VStack(spacing: Spacing.lg) {
            ZStack {
                Circle()
                    .fill(Color.bloomPrimary.opacity(0.1))
                    .frame(width: 80, height: 80)

                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(Color.bloomGradient)
            }

            VStack(spacing: Spacing.sm) {
                Text("Your AI Wellness Coach")
                    .font(.bloomTitleMedium)
                    .foregroundColor(.bloomTextPrimary)

                Text("Ask me about sleep tips, stress management, building habits, or anything wellness-related.")
                    .font(.bloomBodyMedium)
                    .foregroundColor(.bloomTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, Spacing.xl)

            VStack(spacing: Spacing.sm) {
                suggestionChip("How can I sleep better?")
                suggestionChip("Help me reduce stress")
                suggestionChip("Tips for more energy")
            }
        }
        .padding(.vertical, Spacing.xl)
    }

    private func suggestionChip(_ text: String) -> some View {
        Text(text)
            .font(.bloomBodySmall)
            .foregroundColor(.bloomPrimary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm)
            .background(
                Capsule()
                    .stroke(Color.bloomPrimary.opacity(0.3), lineWidth: 1)
            )
    }
}

struct PremiumFeatureEmptyState: View {
    let feature: String
    let onUpgrade: () -> Void

    var body: some View {
        VStack(spacing: Spacing.lg) {
            Spacer()

            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.bloomSecondary.opacity(0.2), Color.bloomPrimary.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)

                Image(systemName: "crown.fill")
                    .font(.system(size: 44))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.bloomSecondary, Color.bloomPrimary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }

            VStack(spacing: Spacing.sm) {
                Text("Unlock \(feature)")
                    .font(.bloomTitleLarge)
                    .foregroundColor(.bloomTextPrimary)
                    .multilineTextAlignment(.center)

                Text("Upgrade to Bloom Premium for unlimited AI insights, advanced analytics, and more.")
                    .font(.bloomBodyMedium)
                    .foregroundColor(.bloomTextSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, Spacing.xl)

            Button(action: {
                HapticManager.shared.impact(.medium)
                onUpgrade()
            }) {
                HStack(spacing: Spacing.sm) {
                    Image(systemName: "crown.fill")
                    Text("Upgrade to Premium")
                }
                .font(.bloomBodyMedium)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, Spacing.xl)
                .padding(.vertical, Spacing.md)
                .background(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [Color.bloomSecondary, Color.bloomPrimary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                )
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Previews

#Preview("Empty States") {
    ScrollView {
        VStack(spacing: Spacing.xxl) {
            Text("No Check-Ins")
                .font(.bloomTitleSmall)
            NoCheckInsEmptyState(onStartCheckIn: {})
                .frame(height: 300)

            Divider()

            Text("No Habits")
                .font(.bloomTitleSmall)
            NoHabitsEmptyState(onCreateHabit: {})
                .frame(height: 300)

            Divider()

            Text("No Chat Messages")
                .font(.bloomTitleSmall)
            NoChatMessagesEmptyState()

            Divider()

            Text("Premium Feature")
                .font(.bloomTitleSmall)
            PremiumFeatureEmptyState(feature: "AI Chat", onUpgrade: {})
                .frame(height: 350)
        }
        .padding()
    }
    .background(Color.bloomAdaptiveBackground)
}
