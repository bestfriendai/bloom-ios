//
//  HapticManager.swift
//  Bloom
//
//  Centralized haptic feedback management
//

import UIKit
import SwiftUI

/// Manager for haptic feedback throughout the app
final class HapticManager: @unchecked Sendable {
    static let shared = HapticManager()

    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let softImpact = UIImpactFeedbackGenerator(style: .soft)
    private let rigidImpact = UIImpactFeedbackGenerator(style: .rigid)
    private let selectionFeedback = UISelectionFeedbackGenerator()
    private let notificationFeedback = UINotificationFeedbackGenerator()

    private init() {
        // Prepare generators for faster response
        prepareAll()
    }

    // MARK: - Preparation

    func prepareAll() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
        softImpact.prepare()
        rigidImpact.prepare()
        selectionFeedback.prepare()
        notificationFeedback.prepare()
    }

    // MARK: - Impact Feedback

    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        switch style {
        case .light:
            lightImpact.impactOccurred()
        case .medium:
            mediumImpact.impactOccurred()
        case .heavy:
            heavyImpact.impactOccurred()
        case .soft:
            softImpact.impactOccurred()
        case .rigid:
            rigidImpact.impactOccurred()
        @unknown default:
            mediumImpact.impactOccurred()
        }
    }

    // MARK: - Selection Feedback

    func selection() {
        selectionFeedback.selectionChanged()
    }

    // MARK: - Notification Feedback

    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationFeedback.notificationOccurred(type)
    }

    func success() {
        notification(.success)
    }

    func warning() {
        notification(.warning)
    }

    func error() {
        notification(.error)
    }

    // MARK: - Semantic Haptics

    /// Light tap for buttons and selections
    func buttonTap() {
        impact(.light)
    }

    /// Soft feedback for toggles and switches
    func toggle() {
        impact(.soft)
    }

    /// Medium feedback for completing actions
    func complete() {
        success()
    }

    /// Heavy feedback for important actions
    func important() {
        impact(.heavy)
    }

    /// Rigid feedback for slider snaps
    func snap() {
        impact(.rigid)
    }
}

// MARK: - SwiftUI View Modifier

struct HapticFeedbackModifier: ViewModifier {
    let style: UIImpactFeedbackGenerator.FeedbackStyle

    func body(content: Content) -> some View {
        content
            .onTapGesture {
                HapticManager.shared.impact(style)
            }
    }
}

extension View {
    /// Adds haptic feedback on tap
    func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle = .light) -> some View {
        self.modifier(HapticFeedbackModifier(style: style))
    }

    /// Adds selection haptic feedback
    func hapticSelection() -> some View {
        self.onTapGesture {
            HapticManager.shared.selection()
        }
    }
}

// MARK: - Button Style with Haptics

struct HapticButtonStyle: ButtonStyle {
    var impactStyle: UIImpactFeedbackGenerator.FeedbackStyle = .light

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.bloomQuick, value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { _, isPressed in
                if isPressed {
                    HapticManager.shared.impact(impactStyle)
                }
            }
    }
}
