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
    @Published var showEditNameSheet = false
    @Published var editedName: String = ""
    @Published var goals: [String] = []
    @Published var updateError: String?

    private let userProfileRepository: UserProfileRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository()) {
        self.userProfileRepository = userProfileRepository

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

        NotificationCenter.default.publisher(for: .dayProgressSaved)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                guard let self else { return }
                if let streak = notification.userInfo?["currentStreak"] as? Int {
                    self.userProfile.currentStreak = streak
                    self.updateChallengeFromProfile()
                    self.updateGoalsCompletion(currentStreak: streak)
                }
            }
            .store(in: &cancellables)
    }

    private func loadUserProfile() {
        isLoading = true

        if let localProfile = userProfileRepository.loadProfileLocally() {
            userProfile = localProfile
            editedName = localProfile.displayName ?? localProfile.name
            goals = localProfile.goals
            updateChallengeFromProfile()
            isLoading = false
        }

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
                    if let profile {
                        self?.userProfile = profile
                        self?.editedName = profile.displayName ?? profile.name
                        self?.goals = profile.goals
                        self?.updateChallengeFromProfile()
                        self?.updateGoalsCompletion(currentStreak: profile.currentStreak)
                    }
                }
            )
            .store(in: &cancellables)
    }

    private func updateChallengeFromProfile() {
        currentChallenge.currentDay = userProfile.currentStreak
        updateGoalsCompletion(currentStreak: userProfile.currentStreak)
    }

    private func setupMilestones() {
        milestones = [
            Milestone(title: "First Week", description: "Complete 7 consecutive days", isCompleted: false),
            Milestone(title: "Two Weeks", description: "Complete 14 consecutive days", isCompleted: false),
            Milestone(title: "One Month", description: "Complete 30 consecutive days", isCompleted: false),
            Milestone(title: "Halfway There", description: "Complete 37 consecutive days", isCompleted: false),
            Milestone(title: "75 Hard Complete", description: "Finish the entire 75 Hard challenge", isCompleted: false),
            Milestone(title: "Perfect Week", description: "Complete all daily tasks for 7 days", isCompleted: false)
        ]
    }

    func editProfile() {
        editedName = userProfile.displayName ?? userProfile.name
        updateError = nil
        showEditNameSheet = true
    }

    func saveEditedName() {
        let trimmed = editedName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            updateError = "Name must be at least 2 characters long."
            return
        }

        isLoading = true
        userProfileRepository.updateDisplayName(trimmed, displayName: trimmed)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.updateError = error.userFriendlyMessage
                }
            } receiveValue: { [weak self] updatedProfile in
                self?.userProfile = updatedProfile
                self?.editedName = updatedProfile.displayName ?? updatedProfile.name
                self?.updateError = nil
                self?.updateChallengeFromProfile()
                self?.showEditNameSheet = false
            }
            .store(in: &cancellables)
    }

    func updateGoalsCompletion(currentStreak: Int) {
        for index in milestones.indices {
            switch milestones[index].title {
            case "First Week":
                milestones[index].isCompleted = currentStreak >= 7
            case "Two Weeks":
                milestones[index].isCompleted = currentStreak >= 14
            case "One Month":
                milestones[index].isCompleted = currentStreak >= 30
            case "Halfway There":
                milestones[index].isCompleted = currentStreak >= 37
            case "75 Hard Complete":
                milestones[index].isCompleted = currentStreak >= 75
            case "Perfect Week":
                milestones[index].isCompleted = currentStreak >= 7 && userProfile.totalDays >= 7
            default:
                break
            }
        }
    }
}
