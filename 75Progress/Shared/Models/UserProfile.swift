//
//  UserProfile.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation

struct UserProfile: Identifiable {
    let id = UUID()
    let name: String
    let email: String
    var currentStreak: Int
    var totalDays: Int
    var completedChallenges: Int
} 