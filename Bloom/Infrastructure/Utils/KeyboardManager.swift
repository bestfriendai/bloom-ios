//
//  KeyboardManager.swift
//  Bloom
//
//  Keyboard handling utilities
//

import SwiftUI
import Combine

// MARK: - Keyboard Dismiss Modifier

struct KeyboardDismissModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .onTapGesture {
                hideKeyboard()
            }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

extension View {
    /// Dismisses keyboard when tapping outside of text fields
    func dismissKeyboardOnTap() -> some View {
        self.modifier(KeyboardDismissModifier())
    }

    /// Hides the keyboard programmatically
    func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

// MARK: - Keyboard Avoiding Container

struct KeyboardAvoidingContainer<Content: View>: View {
    @ViewBuilder let content: () -> Content

    @State private var keyboardHeight: CGFloat = 0

    var body: some View {
        content()
            .padding(.bottom, keyboardHeight)
            .animation(.easeOut(duration: 0.25), value: keyboardHeight)
            .onReceive(Publishers.keyboardHeight) { height in
                keyboardHeight = height
            }
    }
}

// MARK: - Keyboard Height Publisher

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0
            }

        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in 0 }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

// MARK: - Focus State Helpers

extension View {
    /// Submits form and moves to next field or dismisses keyboard
    func submitLabel(_ label: SubmitLabel, action: @escaping () -> Void) -> some View {
        self
            .submitLabel(label)
            .onSubmit(action)
    }
}

// MARK: - Keyboard Toolbar

struct KeyboardToolbar: ViewModifier {
    let onDone: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        hideKeyboard()
                        onDone()
                    }
                    .font(.bloomBodyMedium)
                    .foregroundColor(.bloomPrimary)
                }
            }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}

extension View {
    /// Adds a Done button to the keyboard toolbar
    func keyboardDoneButton(action: @escaping () -> Void = {}) -> some View {
        self.modifier(KeyboardToolbar(onDone: action))
    }
}
