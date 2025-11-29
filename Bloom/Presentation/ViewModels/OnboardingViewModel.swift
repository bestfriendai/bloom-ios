//
//  OnboardingViewModel.swift
//  Bloom
//
//  ViewModel for onboarding flow with wellness goal selection
//

import SwiftUI
import Combine

@Observable
final class OnboardingViewModel {
    // MARK: - Published State

    var currentPage = 0
    var selectedGoals: Set<WellnessGoal> = []
    var hasCompletedOnboarding = false

    let totalPages = 4

    // MARK: - Available Goals

    let availableGoals: [WellnessGoal] = [
        WellnessGoal(id: "sleep", icon: "moon.stars.fill", title: "Better Sleep", color: .bloomPrimary),
        WellnessGoal(id: "stress", icon: "heart.fill", title: "Reduce Stress", color: .bloomCoral),
        WellnessGoal(id: "energy", icon: "bolt.fill", title: "More Energy", color: .bloomGreen),
        WellnessGoal(id: "mindfulness", icon: "brain.head.profile", title: "Mindfulness", color: .bloomPrimary),
        WellnessGoal(id: "exercise", icon: "figure.walk", title: "Exercise More", color: .bloomCoral),
        WellnessGoal(id: "gratitude", icon: "sparkles", title: "Practice Gratitude", color: .bloomGreen)
    ]

    // MARK: - Use Cases (to be injected)
    // private let saveUserGoalsUseCase: SaveUserGoalsUseCase
    // private let completeOnboardingUseCase: CompleteOnboardingUseCase

    // MARK: - Initialization

    init(
        // saveUserGoalsUseCase: SaveUserGoalsUseCase,
        // completeOnboardingUseCase: CompleteOnboardingUseCase
    ) {
        // self.saveUserGoalsUseCase = saveUserGoalsUseCase
        // self.completeOnboardingUseCase = completeOnboardingUseCase
    }

    // MARK: - Navigation

    /// Advances to the next onboarding page
    func nextPage() {
        guard currentPage < totalPages - 1 else { return }

        withAnimation(.bloomSmooth) {
            currentPage += 1
        }
    }

    /// Returns to the previous onboarding page
    func previousPage() {
        guard currentPage > 0 else { return }

        withAnimation(.bloomSmooth) {
            currentPage -= 1
        }
    }

    /// Jumps to a specific page
    func goToPage(_ page: Int) {
        guard page >= 0 && page < totalPages else { return }

        withAnimation(.bloomSmooth) {
            currentPage = page
        }
    }

    // MARK: - Goal Selection

    /// Toggles selection state for a wellness goal
    func toggleGoal(_ goal: WellnessGoal) {
        withAnimation(.bloomBouncy) {
            if selectedGoals.contains(goal) {
                selectedGoals.remove(goal)
            } else {
                selectedGoals.insert(goal)
            }
        }
    }

    /// Checks if a specific goal is selected
    func isGoalSelected(_ goal: WellnessGoal) -> Bool {
        selectedGoals.contains(goal)
    }

    // MARK: - Completion

    /// Completes onboarding and saves user's selected goals
    /// Calls: SaveUserGoalsUseCase, CompleteOnboardingUseCase
    @MainActor
    func completeOnboarding() async {
        guard canCompleteOnboarding else { return }

        do {
            // Convert selected goals to domain format
            let goalIds = selectedGoals.map { $0.id }

            // TODO: Call SaveUserGoalsUseCase
            // try await saveUserGoalsUseCase.execute(goals: goalIds)

            // TODO: Call CompleteOnboardingUseCase
            // try await completeOnboardingUseCase.execute()

            // Simulate API call
            try await Task.sleep(nanoseconds: 500_000_000)

            hasCompletedOnboarding = true

        } catch {
            // Handle error (could add error state property if needed)
            print("Failed to complete onboarding: \(error)")
        }
    }

    // MARK: - Validation

    /// Checks if user can proceed to complete onboarding
    var canCompleteOnboarding: Bool {
        !selectedGoals.isEmpty && currentPage == totalPages - 1
    }

    /// Checks if the "Get Started" button should be enabled
    var isGetStartedEnabled: Bool {
        !selectedGoals.isEmpty
    }

    // MARK: - Progress

    /// Returns the current progress as a percentage (0.0 to 1.0)
    var progress: Double {
        Double(currentPage + 1) / Double(totalPages)
    }

    /// Checks if we're on the first page
    var isFirstPage: Bool {
        currentPage == 0
    }

    /// Checks if we're on the last page
    var isLastPage: Bool {
        currentPage == totalPages - 1
    }

    /// Checks if we're on the goal selection page
    var isGoalSelectionPage: Bool {
        currentPage == totalPages - 1
    }

    // MARK: - Helper Methods

    /// Resets onboarding state (useful for testing or re-onboarding)
    func reset() {
        currentPage = 0
        selectedGoals.removeAll()
        hasCompletedOnboarding = false
    }
}
