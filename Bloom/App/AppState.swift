//
//  AppState.swift
//  Bloom
//
//  Global application state management
//

import SwiftUI
import Combine

/// Global application state observable across the app
@Observable
@MainActor
final class AppState {
    // MARK: - Authentication State

    var isAuthenticated = false
    var currentUser: UserProfile?
    var hasCompletedOnboarding = false

    // MARK: - Navigation State

    var selectedTab: Tab = .home
    var showingPaywall = false

    // MARK: - Loading States

    var isLoading = false
    var loadingMessage: String?

    // MARK: - Error State

    var currentError: AppError?
    var showingError = false

    // MARK: - Subscription State

    var isPremium: Bool {
        currentUser?.subscriptionTier == .premium
    }

    // MARK: - Tab Definition

    enum Tab: String, CaseIterable {
        case home = "Home"
        case habits = "Habits"
        case progress = "Progress"
        case settings = "Settings"

        var icon: String {
            switch self {
            case .home: return "house.fill"
            case .habits: return "checkmark.circle.fill"
            case .progress: return "chart.line.uptrend.xyaxis"
            case .settings: return "gearshape.fill"
            }
        }
    }

    // MARK: - Methods

    func signIn(user: UserProfile) {
        currentUser = user
        isAuthenticated = true
    }

    func signOut() {
        currentUser = nil
        isAuthenticated = false
        hasCompletedOnboarding = false
        selectedTab = .home
    }

    func completeOnboarding() {
        hasCompletedOnboarding = true
    }

    func showError(_ error: AppError) {
        currentError = error
        showingError = true
    }

    func dismissError() {
        showingError = false
        currentError = nil
    }

    func showLoading(_ message: String? = nil) {
        loadingMessage = message
        isLoading = true
    }

    func hideLoading() {
        isLoading = false
        loadingMessage = nil
    }
}

/// Application-wide error type
enum AppError: Error, LocalizedError, Identifiable {
    case auth(AuthError)
    case checkIn(CheckInError)
    case habit(HabitError)
    case user(UserError)
    case aiInsight(AIInsightError)
    case network
    case unknown(String)

    var id: String {
        errorDescription ?? "unknown"
    }

    var errorDescription: String? {
        switch self {
        case .auth(let error):
            return error.errorDescription
        case .checkIn(let error):
            return error.errorDescription
        case .habit(let error):
            return error.errorDescription
        case .user(let error):
            return error.errorDescription
        case .aiInsight(let error):
            return error.errorDescription
        case .network:
            return "Network error. Please check your connection."
        case .unknown(let message):
            return message
        }
    }

    var recoverySuggestion: String? {
        switch self {
        case .network:
            return "Please check your internet connection and try again."
        case .auth(.tooManyRequests):
            return "Wait a few minutes before trying again."
        case .aiInsight(.rateLimitExceeded):
            return "Upgrade to premium for unlimited AI insights."
        case .habit(.maxHabitsReached):
            return "Upgrade to premium for up to 10 habits."
        default:
            return nil
        }
    }
}
