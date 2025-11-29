//
//  CardView.swift
//  Bloom
//
//  Reusable card container component
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    var padding: CGFloat = Spacing.cardPadding

    init(padding: CGFloat = Spacing.cardPadding, @ViewBuilder content: () -> Content) {
        self.padding = padding
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(Color.bloomCard)
            .cornerRadius(Spacing.cornerRadius)
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    CardView {
        VStack(alignment: .leading, spacing: Spacing.sm) {
            Text("Welcome to Bloom")
                .font(.bloomHeadlineSmall)
                .foregroundColor(.bloomTextPrimary)

            Text("Start your wellness journey today")
                .font(.bloomBodyMedium)
                .foregroundColor(.bloomTextSecondary)
        }
    }
    .padding()
    .background(Color.bloomAdaptiveBackground)
}
