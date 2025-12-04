//
//  CustomTextField.swift
//  Bloom
//
//  Custom text field component with Bloom styling
//

import SwiftUI

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String?
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences

    @FocusState private var isFocused: Bool
    @State private var isPasswordVisible: Bool = false

    var body: some View {
        HStack(spacing: Spacing.sm) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.bloomBodyLarge)
                    .foregroundColor(isFocused ? .bloomPrimary : .bloomTextSecondary)
                    .frame(width: 24)
            }

            Group {
                if isSecure && !isPasswordVisible {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                        .textInputAutocapitalization(autocapitalization)
                }
            }
            .font(.bloomBodyLarge)
            .foregroundColor(.bloomTextPrimary)
            .focused($isFocused)

            if isSecure {
                Button(action: { isPasswordVisible.toggle() }) {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .font(.bloomBodyLarge)
                        .foregroundColor(.bloomTextSecondary)
                }
            }
        }
        .padding(.horizontal, Spacing.md)
        .padding(.vertical, Spacing.md)
        .background(Color.bloomCard)
        .overlay(
            RoundedRectangle(cornerRadius: Spacing.cornerRadiusSmall)
                .stroke(isFocused ? Color.bloomPrimary : Color.clear, lineWidth: 2)
        )
        .cornerRadius(Spacing.cornerRadiusSmall)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: Spacing.md) {
        CustomTextField(
            placeholder: "Email",
            text: .constant(""),
            icon: "envelope.fill",
            keyboardType: .emailAddress,
            autocapitalization: .never
        )

        CustomTextField(
            placeholder: "Password",
            text: .constant(""),
            icon: "lock.fill",
            isSecure: true
        )

        CustomTextField(
            placeholder: "Name",
            text: .constant("John Doe"),
            icon: "person.fill"
        )
    }
    .padding()
    .background(Color.bloomAdaptiveBackground)
}
