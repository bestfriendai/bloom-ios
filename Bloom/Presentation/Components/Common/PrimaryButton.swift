//
//  PrimaryButton.swift
//  Bloom
//
//  Primary button component
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var style: ButtonStyle = .primary
    var accessibilityHint: String?

    enum ButtonStyle {
        case primary
        case secondary
        case outline
    }

    var body: some View {
        Button {
            HapticManager.shared.buttonTap()
            action()
        } label: {
            HStack(spacing: Spacing.xs) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: textColor))
                        .scaleEffect(0.9)
                } else {
                    Text(title)
                        .font(.bloomTitleMedium)
                        .fontWeight(.semibold)
                }
            }
            .foregroundColor(textColor)
            .frame(maxWidth: .infinity)
            .frame(height: Spacing.buttonHeight)
            .background(backgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: Spacing.cornerRadius)
                    .stroke(borderColor, lineWidth: style == .outline ? 2 : 0)
            )
            .cornerRadius(Spacing.cornerRadius)
        }
        .disabled(isLoading)
        .buttonStyle(ScaleButtonStyle())
        .accessibilityLabel(title)
        .accessibilityHint(accessibilityHint ?? (isLoading ? "Loading, please wait" : ""))
        .accessibilityAddTraits(.isButton)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return .bloomPrimary
        case .secondary:
            return .bloomSecondary
        case .outline:
            return .clear
        }
    }

    private var textColor: Color {
        switch style {
        case .primary, .secondary:
            return .white
        case .outline:
            return .bloomPrimary
        }
    }

    private var borderColor: Color {
        style == .outline ? .bloomPrimary : .clear
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.bloomQuick, value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        PrimaryButton(title: "Continue", action: {})
        PrimaryButton(title: "Sign In", action: {}, style: .secondary)
        PrimaryButton(title: "Skip", action: {}, style: .outline)
        PrimaryButton(title: "Loading...", action: {}, isLoading: true)
    }
    .padding()
}
