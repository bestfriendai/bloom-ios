//
//  DailyCheckInModel.swift
//  Bloom
//
//  SwiftData model for daily check-in persistence
//

import Foundation
import SwiftData

@Model
final class DailyCheckInModel {
    @Attribute(.unique) var id: String
    var userId: String
    var timestamp: Date
    var moodScore: Int
    var energyScore: Int
    var sleepHours: Double
    var sleepQuality: Int
    var notes: String?
    var aiInsight: String?
    var isMorning: Bool
    var isSynced: Bool

    init(
        id: String = UUID().uuidString,
        userId: String,
        timestamp: Date = Date(),
        moodScore: Int,
        energyScore: Int,
        sleepHours: Double,
        sleepQuality: Int,
        notes: String? = nil,
        aiInsight: String? = nil,
        isMorning: Bool = true,
        isSynced: Bool = false
    ) {
        self.id = id
        self.userId = userId
        self.timestamp = timestamp
        self.moodScore = moodScore
        self.energyScore = energyScore
        self.sleepHours = sleepHours
        self.sleepQuality = sleepQuality
        self.notes = notes
        self.aiInsight = aiInsight
        self.isMorning = isMorning
        self.isSynced = isSynced
    }
}

// MARK: - Domain Conversion

extension DailyCheckInModel {
    func toDomain() -> DailyCheckIn {
        DailyCheckIn(
            id: id,
            userId: userId,
            timestamp: timestamp,
            moodScore: moodScore,
            energyScore: energyScore,
            sleepHours: sleepHours,
            sleepQuality: sleepQuality,
            notes: notes,
            aiInsight: aiInsight,
            isMorning: isMorning
        )
    }

    convenience init(from domain: DailyCheckIn) {
        self.init(
            id: domain.id,
            userId: domain.userId,
            timestamp: domain.timestamp,
            moodScore: domain.moodScore,
            energyScore: domain.energyScore,
            sleepHours: domain.sleepHours,
            sleepQuality: domain.sleepQuality,
            notes: domain.notes,
            aiInsight: domain.aiInsight,
            isMorning: domain.isMorning
        )
    }
}
