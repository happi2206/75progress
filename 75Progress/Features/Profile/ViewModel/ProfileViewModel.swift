//
//  ProfileViewModel.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Foundation

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var currentChallenge: Challenge
    @Published var milestones: [Milestone] = []
    
    init() {
        self.userProfile = UserProfile(
            name: "John Doe",
            email: "john.doe@example.com",
            currentStreak: 14,
            totalDays: 45,
            completedChallenges: 2
        )
        
        self.currentChallenge = Challenge(
            name: "75 Hard",
            currentDay: 14,
            totalDays: 75,
            isActive: true
        )
        
        setupMilestones()
    }
    
    private func setupMilestones() {
        milestones = [
            Milestone(
                title: "First Week",
                description: "Complete 7 consecutive days",
                isCompleted: true
            ),
            Milestone(
                title: "Two Weeks",
                description: "Complete 14 consecutive days",
                isCompleted: true
            ),
            Milestone(
                title: "One Month",
                description: "Complete 30 consecutive days",
                isCompleted: false
            ),
            Milestone(
                title: "Halfway There",
                description: "Complete 37 consecutive days",
                isCompleted: false
            ),
            Milestone(
                title: "75 Hard Complete",
                description: "Finish the entire 75 Hard challenge",
                isCompleted: false
            ),
            Milestone(
                title: "Perfect Week",
                description: "Complete all daily tasks for 7 days",
                isCompleted: false
            )
        ]
    }
    
    func editProfile() {
        // Handle profile editing
        print("Edit profile tapped")
    }
    
    func createNewChallenge() {
        // Handle creating new challenge
        print("Create new challenge tapped")
    }
    
    func updateStreak() {
        // Update current streak
        userProfile.currentStreak += 1
        userProfile.totalDays += 1
    }
} 