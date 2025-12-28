//
//  SkeletonView.swift
//  Bloom
//
//  Shimmer loading skeleton for elegant loading states
//

import SwiftUI

// MARK: - Skeleton View Modifier

struct SkeletonModifier: ViewModifier {
    @State private var isAnimating = false

    let isLoading: Bool
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        if isLoading {
            content
                .hidden()
                .overlay(
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .fill(Color.bloomTextSecondary.opacity(0.1))
                        .overlay(
                            GeometryReader { geometry in
                                shimmerGradient
                                    .frame(width: geometry.size.width * 2)
                                    .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                            }
                            .mask(
                                RoundedRectangle(cornerRadius: cornerRadius)
                            )
                        )
                )
                .onAppear {
                    withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                        isAnimating = true
                    }
                }
        } else {
            content
        }
    }

    private var shimmerGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.clear,
                Color.white.opacity(0.4),
                Color.clear
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

extension View {
    func skeleton(isLoading: Bool, cornerRadius: CGFloat = 8) -> some View {
        modifier(SkeletonModifier(isLoading: isLoading, cornerRadius: cornerRadius))
    }
}

// MARK: - Skeleton Shapes

struct SkeletonLine: View {
    let width: CGFloat?
    let height: CGFloat

    @State private var isAnimating = false

    init(width: CGFloat? = nil, height: CGFloat = 16) {
        self.width = width
        self.height = height
    }

    var body: some View {
        RoundedRectangle(cornerRadius: height / 2)
            .fill(Color.bloomTextSecondary.opacity(0.1))
            .frame(width: width, height: height)
            .overlay(
                GeometryReader { geometry in
                    shimmerGradient
                        .frame(width: geometry.size.width * 2)
                        .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                }
                .mask(
                    RoundedRectangle(cornerRadius: height / 2)
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }

    private var shimmerGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.clear,
                Color.white.opacity(0.4),
                Color.clear
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct SkeletonCircle: View {
    let size: CGFloat

    @State private var isAnimating = false

    init(size: CGFloat = 48) {
        self.size = size
    }

    var body: some View {
        Circle()
            .fill(Color.bloomTextSecondary.opacity(0.1))
            .frame(width: size, height: size)
            .overlay(
                shimmerGradient
                    .frame(width: size * 2)
                    .offset(x: isAnimating ? size : -size)
                    .mask(Circle())
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }

    private var shimmerGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.clear,
                Color.white.opacity(0.4),
                Color.clear
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

struct SkeletonRectangle: View {
    let width: CGFloat?
    let height: CGFloat
    let cornerRadius: CGFloat

    @State private var isAnimating = false

    init(width: CGFloat? = nil, height: CGFloat = 100, cornerRadius: CGFloat = 12) {
        self.width = width
        self.height = height
        self.cornerRadius = cornerRadius
    }

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(Color.bloomTextSecondary.opacity(0.1))
            .frame(width: width, height: height)
            .overlay(
                GeometryReader { geometry in
                    shimmerGradient
                        .frame(width: geometry.size.width * 2)
                        .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                }
                .mask(
                    RoundedRectangle(cornerRadius: cornerRadius)
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }

    private var shimmerGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color.clear,
                Color.white.opacity(0.4),
                Color.clear
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

// MARK: - Pre-built Skeleton Layouts

/// Skeleton for a habit card
struct HabitCardSkeleton: View {
    var body: some View {
        HStack(spacing: Spacing.md) {
            SkeletonCircle(size: 48)

            VStack(alignment: .leading, spacing: Spacing.xs) {
                SkeletonLine(width: 120, height: 18)
                SkeletonLine(width: 80, height: 14)
            }

            Spacer()

            SkeletonRectangle(width: 32, height: 32, cornerRadius: 8)
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.bloomSurface)
        )
    }
}

/// Skeleton for check-in insight card
struct InsightCardSkeleton: View {
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.md) {
            HStack(spacing: Spacing.sm) {
                SkeletonCircle(size: 32)
                SkeletonLine(width: 100, height: 16)
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                SkeletonLine(height: 14)
                SkeletonLine(height: 14)
                SkeletonLine(width: 200, height: 14)
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.bloomSurface)
        )
    }
}

/// Skeleton for weekly stats card
struct StatsCardSkeleton: View {
    var body: some View {
        VStack(spacing: Spacing.md) {
            HStack {
                SkeletonLine(width: 120, height: 18)
                Spacer()
            }

            HStack(spacing: Spacing.lg) {
                ForEach(0..<3, id: \.self) { _ in
                    VStack(spacing: Spacing.xs) {
                        SkeletonCircle(size: 56)
                        SkeletonLine(width: 50, height: 12)
                    }
                }
            }
        }
        .padding(Spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.bloomSurface)
        )
    }
}

/// Skeleton for a list of items
struct ListSkeleton: View {
    let itemCount: Int

    init(itemCount: Int = 5) {
        self.itemCount = itemCount
    }

    var body: some View {
        VStack(spacing: Spacing.md) {
            ForEach(0..<itemCount, id: \.self) { _ in
                HStack(spacing: Spacing.md) {
                    SkeletonCircle(size: 44)

                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        SkeletonLine(width: 140, height: 16)
                        SkeletonLine(width: 100, height: 12)
                    }

                    Spacer()
                }
                .padding(Spacing.sm)
            }
        }
    }
}

/// Skeleton for a check-in history item
struct CheckInHistorySkeleton: View {
    var body: some View {
        HStack(spacing: Spacing.md) {
            VStack(spacing: Spacing.xxs) {
                SkeletonLine(width: 30, height: 12)
                SkeletonLine(width: 24, height: 24)
            }

            VStack(alignment: .leading, spacing: Spacing.xs) {
                SkeletonLine(width: 80, height: 14)

                HStack(spacing: Spacing.sm) {
                    SkeletonRectangle(width: 60, height: 24, cornerRadius: 12)
                    SkeletonRectangle(width: 60, height: 24, cornerRadius: 12)
                    SkeletonRectangle(width: 60, height: 24, cornerRadius: 12)
                }
            }

            Spacer()
        }
        .padding(Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.bloomSurface)
        )
    }
}

// MARK: - Previews

#Preview("Skeleton Components") {
    ScrollView {
        VStack(spacing: Spacing.xl) {
            Group {
                Text("Lines")
                    .font(.bloomTitleMedium)
                SkeletonLine()
                SkeletonLine(width: 200)
                SkeletonLine(width: 150, height: 24)
            }

            Group {
                Text("Shapes")
                    .font(.bloomTitleMedium)
                HStack(spacing: Spacing.md) {
                    SkeletonCircle(size: 32)
                    SkeletonCircle(size: 48)
                    SkeletonCircle(size: 64)
                }
            }

            Group {
                Text("Habit Card")
                    .font(.bloomTitleMedium)
                HabitCardSkeleton()
            }

            Group {
                Text("Insight Card")
                    .font(.bloomTitleMedium)
                InsightCardSkeleton()
            }

            Group {
                Text("Stats Card")
                    .font(.bloomTitleMedium)
                StatsCardSkeleton()
            }
        }
        .padding()
    }
    .background(Color.bloomAdaptiveBackground)
}
