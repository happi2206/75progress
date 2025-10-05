//
//  UserProfile.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation

struct UserProfile: Identifiable, Codable {
    let id: UUID
    let name: String
    let email: String
    var currentStreak: Int
    var totalDays: Int
    var completedChallenges: Int
    var displayName: String?
    var goals: [String]
    let createdAt: Date
    var lastUpdated: Date
    var deviceID: String?
    
    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        currentStreak: Int = 0,
        totalDays: Int = 0,
        completedChallenges: Int = 0,
        displayName: String? = nil,
        goals: [String] = [],
        createdAt: Date = Date(),
        lastUpdated: Date = Date(),
        deviceID: String? = nil
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.currentStreak = currentStreak
        self.totalDays = totalDays
        self.completedChallenges = completedChallenges
        self.displayName = displayName
        self.goals = goals
        self.createdAt = createdAt
        self.lastUpdated = lastUpdated
        self.deviceID = deviceID
    }
} 