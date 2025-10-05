//
//  ProfileViewModel.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var currentChallenge: Challenge
    @Published var milestones: [Milestone] = []
    @Published var isLoading = false
    
    private let userProfileRepository: UserProfileRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    
    init(userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository()) {
        self.userProfileRepository = userProfileRepository
        
        // Initialize with default values
        self.userProfile = UserProfile(
            name: "Loading...",
            email: "loading@example.com",
            currentStreak: 0,
            totalDays: 0,
            completedChallenges: 0
        )
        
        self.currentChallenge = Challenge(
            name: "75 Hard",
            currentDay: 0,
            totalDays: 75,
            isActive: true
        )
        
        setupMilestones()
        loadUserProfile()
    }
    
    private func loadUserProfile() {
        isLoading = true
        
        // Try to load from local storage first
        if let localProfile = userProfileRepository.loadProfileLocally() {
            userProfile = localProfile
            updateChallengeFromProfile()
            isLoading = false
        }
        
        // Then try to fetch from Firestore
        userProfileRepository.fetchUserProfile()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        print("Failed to fetch user profile: \(error)")
                    }
                },
                receiveValue: { [weak self] profile in
                    if let profile = profile {
                        self?.userProfile = profile
                        self?.updateChallengeFromProfile()
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func updateChallengeFromProfile() {
        currentChallenge.currentDay = userProfile.currentStreak
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