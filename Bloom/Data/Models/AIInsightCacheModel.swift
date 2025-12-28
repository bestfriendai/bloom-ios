//
//  AIInsightCacheModel.swift
//  Bloom
//
//  SwiftData model for caching AI insights
//

import Foundation
import SwiftData

@Model
final class AIInsightCacheModel {
    @Attribute(.unique) var id: String
    var userId: String
    var checkInId: String?
    var insightText: String
    var insightType: String
    var generatedAt: Date
    var expiresAt: Date

    init(
        id: String = UUID().uuidString,
        userId: String,
        checkInId: String? = nil,
        insightText: String,
        insightType: String = "daily",
        generatedAt: Date = Date(),
        expiresAt: Date = Date().addingTimeInterval(86400) // 24 hours
    ) {
        self.id = id
        self.userId = userId
        self.checkInId = checkInId
        self.insightText = insightText
        self.insightType = insightType
        self.generatedAt = generatedAt
        self.expiresAt = expiresAt
    }

    var isExpired: Bool {
        Date() > expiresAt
    }
}

/// Tracks weekly AI insight usage for free tier rate limiting
@Model
final class AIInsightUsageModel {
    @Attribute(.unique) var id: String
    var userId: String
    var weekStartDate: Date
    var insightCount: Int

    init(
        id: String = UUID().uuidString,
        userId: String,
        weekStartDate: Date = Calendar.current.startOfWeek(for: Date()),
        insightCount: Int = 0
    ) {
        self.id = id
        self.userId = userId
        self.weekStartDate = weekStartDate
        self.insightCount = insightCount
    }

    var remainingFreeInsights: Int {
        max(0, 5 - insightCount)
    }

    func incrementUsage() {
        insightCount += 1
    }
}

// MARK: - Calendar Extension

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        let components = dateComponents([.yearForWeekOfYear, .weekOfYear], from: date)
        return self.date(from: components) ?? date
    }
}
