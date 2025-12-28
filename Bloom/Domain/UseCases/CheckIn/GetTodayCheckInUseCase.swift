//
//  GetTodayCheckInUseCase.swift
//  Bloom
//
//  Use case for retrieving today's check-in
//

import Foundation

/// Use case for getting today's check-in for a user
final class GetTodayCheckInUseCase: Sendable {
    private let checkInRepository: CheckInRepositoryProtocol

    init(checkInRepository: CheckInRepositoryProtocol) {
        self.checkInRepository = checkInRepository
    }

    /// Executes the query for today's check-in
    /// - Parameter userId: The user's ID
    /// - Returns: Today's check-in if it exists, nil otherwise
    func execute(userId: String) async throws -> DailyCheckIn? {
        try await checkInRepository.getTodayCheckIn(userId: userId)
    }
}
