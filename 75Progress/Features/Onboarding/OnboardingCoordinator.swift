//
//  OnboardingCoordinator.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Combine

class OnboardingCoordinator: ObservableObject {
    @Published var showOnboarding = false
    @Published var isOnboardingComplete = false
    
    private let userProfileRepository: UserProfileRepositoryProtocol
    private let toastCenter: ToastCenter
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userProfileRepository: UserProfileRepositoryProtocol = UserProfileRepository(),
        toastCenter: ToastCenter = ToastCenter.shared
    ) {
        self.userProfileRepository = userProfileRepository
        self.toastCenter = toastCenter
        
        checkOnboardingStatus()
    }
    
    private func checkOnboardingStatus() {
        let hasOnboarded = UserDefaults.standard.bool(forKey: "hasOnboarded")
        showOnboarding = !hasOnboarded
        isOnboardingComplete = hasOnboarded
    }
    
    func completeOnboarding() {
        print("🎉 Completing onboarding...")
        UserDefaults.standard.set(true, forKey: "hasOnboarded")
        showOnboarding = false
        isOnboardingComplete = true
        print("✅ Onboarding completed, showOnboarding: \(showOnboarding)")
    }
    
    func resetOnboarding() {
        UserDefaults.standard.set(false, forKey: "hasOnboarded")
        showOnboarding = true
        isOnboardingComplete = false
    }
}
