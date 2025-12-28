//
//  AccessibilityHelpers.swift
//  Bloom
//
//  Accessibility utilities and view modifiers
//

import SwiftUI

// MARK: - Accessibility View Modifiers

extension View {
    /// Adds comprehensive accessibility support for interactive elements
    func accessibleButton(
        label: String,
        hint: String? = nil,
        traits: AccessibilityTraits = .isButton
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(traits)
            .accessibilityRemoveTraits(.isImage)
    }

    /// Adds accessibility support for toggle controls
    func accessibleToggle(
        label: String,
        isOn: Bool,
        hint: String? = nil
    ) -> some View {
        self
            .accessibilityLabel(label)
            .accessibilityValue(isOn ? "On" : "Off")
            .accessibilityHint(hint ?? "Double tap to toggle")
            .accessibilityAddTraits(.isButton)
    }

    /// Adds accessibility support for sliders
    func accessibleSlider(
        label: String,
        value: Double,
        range: ClosedRange<Double>,
        step: Double? = nil
    ) -> some View {
        let percentage = Int(((value - range.lowerBound) / (range.upperBound - range.lowerBound)) * 100)
        return self
            .accessibilityLabel(label)
            .accessibilityValue("\(percentage) percent")
            .accessibilityAdjustableAction { direction in
                // Implementation handled by parent
            }
    }

    /// Adds accessibility support for cards and containers
    func accessibleCard(
        label: String,
        hint: String? = nil
    ) -> some View {
        self
            .accessibilityElement(children: .combine)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
    }

    /// Groups accessibility elements
    func accessibilityGrouped() -> some View {
        self.accessibilityElement(children: .contain)
    }

    /// Hides from accessibility when decorative
    func accessibilityDecorative() -> some View {
        self.accessibilityHidden(true)
    }

    /// Adds accessibility announcement
    func accessibilityAnnounce(_ message: String, when condition: Bool) -> some View {
        self.onChange(of: condition) { _, newValue in
            if newValue {
                UIAccessibility.post(notification: .announcement, argument: message)
            }
        }
    }
}

// MARK: - Accessibility Utilities

struct AccessibilityUtilities {
    /// Posts an accessibility announcement
    static func announce(_ message: String) {
        UIAccessibility.post(notification: .announcement, argument: message)
    }

    /// Posts a screen change notification
    static func screenChanged(focus element: Any? = nil) {
        UIAccessibility.post(notification: .screenChanged, argument: element)
    }

    /// Posts a layout change notification
    static func layoutChanged(focus element: Any? = nil) {
        UIAccessibility.post(notification: .layoutChanged, argument: element)
    }

    /// Checks if VoiceOver is running
    static var isVoiceOverRunning: Bool {
        UIAccessibility.isVoiceOverRunning
    }

    /// Checks if reduce motion is enabled
    static var isReduceMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    /// Checks if bold text is enabled
    static var isBoldTextEnabled: Bool {
        UIAccessibility.isBoldTextEnabled
    }
}

// MARK: - Accessibility-Aware Animation

extension Animation {
    /// Returns reduced animation if accessibility settings require it
    static var accessibleSpring: Animation {
        if AccessibilityUtilities.isReduceMotionEnabled {
            return .easeInOut(duration: 0.1)
        }
        return .bloomSmooth
    }

    /// Returns reduced animation if accessibility settings require it
    static var accessibleBounce: Animation {
        if AccessibilityUtilities.isReduceMotionEnabled {
            return .easeInOut(duration: 0.1)
        }
        return .bloomBouncy
    }
}
