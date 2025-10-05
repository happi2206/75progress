//
//  OnboardingViewModel.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Combine
import UIKit

class OnboardingViewModel: ObservableObject {
    @Published var state = OnboardingState()
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let userProfileRepository: UserProfileRepositoryProtocol
    private let toastCenter: ToastCenter
    private var cancellables = Set<AnyCancellable>()
    
    let coordinator: OnboardingCoordinator
    
    init(
        coordinator: OnboardingCoordinator,
        userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository(),
        toastCenter: ToastCenter = ToastCenter.shared
    ) {
        self.coordinator = coordinator
        self.userProfileRepository = userProfileRepository
        self.toastCenter = toastCenter
    }
    
    // MARK: - Navigation
    
    var canProceed: Bool {
        let currentPage = OnboardingPageData.pages[state.currentPage]
        
        if currentPage.showGoals {
            return state.canProceedFromGoals
        } else if currentPage.showNameInput {
            return state.canFinish
        } else {
            return true
        }
    }
    
    var isLastPage: Bool {
        state.currentPage >= OnboardingPageData.pages.count - 1
    }
    
    func nextPage() {
        guard canProceed else { return }
        
        if isLastPage {
            startChallenge()
        } else {
            withAnimation(.easeInOut(duration: 0.3)) {
                state.currentPage += 1
            }
        }
    }
    
    func previousPage() {
        guard state.currentPage > 0 else { return }
        
        withAnimation(.easeInOut(duration: 0.3)) {
            state.currentPage -= 1
        }
    }
    
    // MARK: - Goal Selection
    
    func toggleGoal(_ goalId: String) {
        if state.selectedGoals.contains(goalId) {
            state.selectedGoals.remove(goalId)
        } else {
            state.selectedGoals.insert(goalId)
        }
    }
    
    func isGoalSelected(_ goalId: String) -> Bool {
        state.selectedGoals.contains(goalId)
    }
    
    // MARK: - Name Input
    
    func updateDisplayName(_ name: String) {
        state.displayName = name
    }
    
    func updateEmail(_ email: String) {
        state.email = email
    }
    
    // MARK: - Challenge Start
    
    private func startChallenge() {
        print("🚀 Starting challenge...")
        isLoading = true
        errorMessage = nil
        
        // Get device ID
        let deviceID = UIDevice.current.identifierForVendor?.uuidString
        
        // Create user profile
        let profile = UserProfile(
            name: state.displayName,
            email: state.email,
            displayName: state.displayName,
            goals: Array(state.selectedGoals),
            deviceID: deviceID
        )
        
        print("📝 Created profile: \(profile.displayName ?? "No name")")
        
        // Sign in anonymously and save profile
        userProfileRepository.signInAnonymously()
            .flatMap { [weak self] uid in
                print("✅ Anonymous sign-in successful: \(uid)")
                return self?.userProfileRepository.upsertUserProfile(profile) ?? Empty().eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    print("📋 Completion received: \(completion)")
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        print("❌ Error: \(error)")
                        self?.errorMessage = error.userFriendlyMessage
                        self?.toastCenter.showError(error)
                    }
                },
                receiveValue: { [weak self] savedProfile in
                    print("✅ Profile saved successfully: \(savedProfile.displayName ?? "No name")")
                    self?.coordinator.completeOnboarding()
                    self?.toastCenter.show("Welcome to 75 Progress!", type: .success)
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Validation
    
    func validateName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= 2 && trimmed.count <= 24 && trimmed.allSatisfy { $0.isLetter || $0.isWhitespace }
    }
    
    func validateEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}
