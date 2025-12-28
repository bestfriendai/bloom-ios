//
//  ToastView.swift
//  Bloom
//
//  Toast and banner notification system for user feedback
//

import SwiftUI

// MARK: - Toast Types

enum ToastType {
    case success
    case error
    case warning
    case info

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .success: return .bloomGreen
        case .error: return .red
        case .warning: return .orange
        case .info: return .bloomPrimary
        }
    }

    var backgroundColor: Color {
        switch self {
        case .success: return Color.bloomGreen.opacity(0.15)
        case .error: return Color.red.opacity(0.15)
        case .warning: return Color.orange.opacity(0.15)
        case .info: return Color.bloomPrimary.opacity(0.15)
        }
    }
}

// MARK: - Toast Message

struct ToastMessage: Identifiable, Equatable {
    let id = UUID()
    let type: ToastType
    let title: String
    let message: String?
    let duration: TimeInterval

    init(type: ToastType, title: String, message: String? = nil, duration: TimeInterval = 3.0) {
        self.type = type
        self.title = title
        self.message = message
        self.duration = duration
    }

    static func == (lhs: ToastMessage, rhs: ToastMessage) -> Bool {
        lhs.id == rhs.id
    }

    static func success(_ title: String, message: String? = nil) -> ToastMessage {
        ToastMessage(type: .success, title: title, message: message)
    }

    static func error(_ title: String, message: String? = nil) -> ToastMessage {
        ToastMessage(type: .error, title: title, message: message, duration: 5.0)
    }

    static func warning(_ title: String, message: String? = nil) -> ToastMessage {
        ToastMessage(type: .warning, title: title, message: message)
    }

    static func info(_ title: String, message: String? = nil) -> ToastMessage {
        ToastMessage(type: .info, title: title, message: message)
    }
}

// MARK: - Toast Manager

@Observable
@MainActor
final class ToastManager {
    static let shared = ToastManager()

    private(set) var currentToast: ToastMessage?
    private var dismissTask: Task<Void, Never>?

    private init() {}

    func show(_ toast: ToastMessage) {
        dismissTask?.cancel()

        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            currentToast = toast
        }

        // Haptic feedback based on type
        switch toast.type {
        case .success:
            HapticManager.shared.notification(.success)
        case .error:
            HapticManager.shared.notification(.error)
        case .warning:
            HapticManager.shared.notification(.warning)
        case .info:
            HapticManager.shared.impact(.light)
        }

        dismissTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(toast.duration * 1_000_000_000))
            if !Task.isCancelled {
                await MainActor.run {
                    dismiss()
                }
            }
        }
    }

    func dismiss() {
        dismissTask?.cancel()
        withAnimation(.easeOut(duration: 0.2)) {
            currentToast = nil
        }
    }

    // Convenience methods
    func success(_ title: String, message: String? = nil) {
        show(.success(title, message: message))
    }

    func error(_ title: String, message: String? = nil) {
        show(.error(title, message: message))
    }

    func warning(_ title: String, message: String? = nil) {
        show(.warning(title, message: message))
    }

    func info(_ title: String, message: String? = nil) {
        show(.info(title, message: message))
    }
}

// MARK: - Toast View

struct ToastView: View {
    let toast: ToastMessage
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: toast.type.icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(toast.type.color)

            VStack(alignment: .leading, spacing: 2) {
                Text(toast.title)
                    .font(.bloomBodyMedium)
                    .fontWeight(.semibold)
                    .foregroundColor(.bloomTextPrimary)

                if let message = toast.message {
                    Text(message)
                        .font(.bloomBodySmall)
                        .foregroundColor(.bloomTextSecondary)
                        .lineLimit(2)
                }
            }

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.bloomTextSecondary)
                    .padding(Spacing.xs)
            }
            .accessibilityLabel("Dismiss notification")
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(toast.type.backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(toast.type.color.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 4)
        .padding(.horizontal, Spacing.md)
    }
}

// MARK: - Toast Container Modifier

struct ToastContainerModifier: ViewModifier {
    @State private var toastManager = ToastManager.shared

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                if let toast = toastManager.currentToast {
                    ToastView(toast: toast) {
                        toastManager.dismiss()
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, Spacing.lg)
                    .zIndex(999)
                }
            }
    }
}

extension View {
    func toastContainer() -> some View {
        modifier(ToastContainerModifier())
    }
}

// MARK: - Inline Error Banner

struct ErrorBanner: View {
    let message: String
    let onDismiss: (() -> Void)?

    init(_ message: String, onDismiss: (() -> Void)? = nil) {
        self.message = message
        self.onDismiss = onDismiss
    }

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 16))
                .foregroundColor(.red)

            Text(message)
                .font(.bloomBodySmall)
                .foregroundColor(.bloomTextPrimary)
                .lineLimit(3)

            Spacer()

            if let onDismiss = onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.bloomTextSecondary)
                        .padding(Spacing.xs)
                }
            }
        }
        .padding(Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.red.opacity(0.1))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Error: \(message)")
    }
}

// MARK: - Success Banner

struct SuccessBanner: View {
    let message: String
    let onDismiss: (() -> Void)?

    init(_ message: String, onDismiss: (() -> Void)? = nil) {
        self.message = message
        self.onDismiss = onDismiss
    }

    var body: some View {
        HStack(spacing: Spacing.sm) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.bloomGreen)

            Text(message)
                .font(.bloomBodySmall)
                .foregroundColor(.bloomTextPrimary)
                .lineLimit(3)

            Spacer()

            if let onDismiss = onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(.bloomTextSecondary)
                        .padding(Spacing.xs)
                }
            }
        }
        .padding(Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.bloomGreen.opacity(0.1))
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Success: \(message)")
    }
}

// MARK: - Info Banner

struct InfoBanner: View {
    let title: String?
    let message: String
    let icon: String

    init(_ message: String, title: String? = nil, icon: String = "info.circle.fill") {
        self.message = message
        self.title = title
        self.icon = icon
    }

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.bloomPrimary)

            VStack(alignment: .leading, spacing: Spacing.xxs) {
                if let title = title {
                    Text(title)
                        .font(.bloomBodyMedium)
                        .fontWeight(.semibold)
                        .foregroundColor(.bloomTextPrimary)
                }

                Text(message)
                    .font(.bloomBodySmall)
                    .foregroundColor(.bloomTextSecondary)
                    .lineSpacing(4)
            }

            Spacer()
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.bloomPrimary.opacity(0.08))
        )
    }
}

// MARK: - Previews

#Preview("Toast Types") {
    VStack(spacing: Spacing.lg) {
        ToastView(toast: .success("Check-in saved!", message: "Keep up the great work")) {}
        ToastView(toast: .error("Connection failed", message: "Please check your internet")) {}
        ToastView(toast: .warning("Low storage", message: "Free up space for best performance")) {}
        ToastView(toast: .info("Tip", message: "Swipe left to delete items")) {}
    }
    .padding()
    .background(Color.bloomAdaptiveBackground)
}

#Preview("Banners") {
    VStack(spacing: Spacing.md) {
        ErrorBanner("Unable to save your check-in. Please try again.") {}

        SuccessBanner("Your data has been exported successfully.") {}

        InfoBanner(
            "Complete 7 consecutive check-ins to unlock weekly insights.",
            title: "Pro Tip",
            icon: "lightbulb.fill"
        )
    }
    .padding()
    .background(Color.bloomAdaptiveBackground)
}

#Preview("Toast Container") {
    Text("Main Content")
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bloomAdaptiveBackground)
        .toastContainer()
        .onAppear {
            ToastManager.shared.success("Welcome back!", message: "Your streak is at 5 days")
        }
}
