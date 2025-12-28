//
//  BloomApp.swift
//  Bloom
//
//  Created by Chris Shireman on 11/25/25.
//

import SwiftUI

@main
struct BloomApp: App {
    @State private var appState = AppState()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    init() {
        SecurityUtil.shared.hardenCache()
        configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootView(hasCompletedOnboarding: hasCompletedOnboarding)
                .environment(appState)
                .onChange(of: appState.hasCompletedOnboarding) { _, completed in
                    if completed {
                        hasCompletedOnboarding = true
                    }
                }
        }
    }

    private func configureAppearance() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance

        // Configure tab bar appearance
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }
}

/// Root view that manages app navigation based on authentication state
struct RootView: View {
    let hasCompletedOnboarding: Bool
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView()
            } else if appState.isAuthenticated {
                MainTabView()
            } else {
                NavigationStack {
                    SignInView()
                }
            }
        }
        .animation(.easeInOut, value: appState.isAuthenticated)
        .animation(.easeInOut, value: hasCompletedOnboarding)
    }
}

/// Main tab view for authenticated users
struct MainTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        TabView(selection: Bindable(appState).selectedTab) {
            HomeView()
                .tabItem {
                    Label(AppState.Tab.home.rawValue, systemImage: AppState.Tab.home.icon)
                }
                .tag(AppState.Tab.home)

            HabitsView()
                .tabItem {
                    Label(AppState.Tab.habits.rawValue, systemImage: AppState.Tab.habits.icon)
                }
                .tag(AppState.Tab.habits)

            ProgressView()
                .tabItem {
                    Label(AppState.Tab.progress.rawValue, systemImage: AppState.Tab.progress.icon)
                }
                .tag(AppState.Tab.progress)

            SettingsView()
                .tabItem {
                    Label(AppState.Tab.settings.rawValue, systemImage: AppState.Tab.settings.icon)
                }
                .tag(AppState.Tab.settings)
        }
        .tint(.bloomPrimary)
    }
}

// MARK: - Placeholder Views (to be implemented)

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ContentView()
                .navigationTitle("Home")
        }
    }
}

struct HabitsView: View {
    var body: some View {
        NavigationStack {
            Text("Habits")
                .navigationTitle("Habits")
        }
    }
}

struct ProgressView: View {
    var body: some View {
        NavigationStack {
            Text("Progress")
                .navigationTitle("Progress")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            Text("Settings")
                .navigationTitle("Settings")
        }
    }
}
