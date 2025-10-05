//
//  OnboardingState.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation

struct OnboardingState: Codable {
    var currentPage: Int = 0
    var selectedGoals: Set<String> = []
    var displayName: String = ""
    var email: String = ""
    var hasCompletedOnboarding: Bool = false
    
    var canProceedFromGoals: Bool {
        !selectedGoals.isEmpty
    }
    
    var canFinish: Bool {
        isValidName(displayName) && isValidEmail(email)
    }
    
    private func isValidName(_ name: String) -> Bool {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.count >= 2 && trimmed.count <= 24 && trimmed.allSatisfy { $0.isLetter || $0.isWhitespace }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email.trimmingCharacters(in: .whitespacesAndNewlines))
    }
}

// MARK: - Onboarding Page Data
struct OnboardingPageData: Codable {
    let id: String
    let title: String
    let body: String
    let bullets: [String]?
    let hashtags: [String]?
    let showGoals: Bool
    let showNameInput: Bool
    let showConsent: Bool
}

extension OnboardingPageData {
    static let pages: [OnboardingPageData] = [
        OnboardingPageData(
            id: "intro",
            title: "Welcome to 75 Progress",
            body: "Transform your life in 75 days with the ultimate challenge that builds discipline, confidence, and lasting habits.",
            bullets: nil,
            hashtags: ["#75Progress", "#Transformation"],
            showGoals: false,
            showNameInput: false,
            showConsent: false
        ),
        OnboardingPageData(
            id: "what_is_75",
            title: "What is 75 Progress?",
            body: "75 Progress is a comprehensive challenge that combines physical fitness, mental development, and habit formation over 75 consecutive days.",
            bullets: [
                "Daily progress photos to track your transformation",
                "Two 45-minute workouts (one must be outdoors)",
                "Follow a strict diet with no cheat meals",
                "Read 10 pages of a non-fiction book daily",
                "Drink 1 gallon of water every day"
            ],
            hashtags: ["#75Hard", "#Challenge"],
            showGoals: false,
            showNameInput: false,
            showConsent: false
        ),
        OnboardingPageData(
            id: "why_75_days",
            title: "Why 75 Days?",
            body: "Research shows that 75 days is the optimal timeframe to form lasting habits and see significant transformation in both body and mind.",
            bullets: [
                "Habit formation requires consistent repetition",
                "Physical changes become visible after 8-12 weeks",
                "Mental discipline strengthens with daily practice",
                "Confidence builds through consistent achievement"
            ],
            hashtags: ["#Science", "#Habits"],
            showGoals: false,
            showNameInput: false,
            showConsent: false
        ),
        OnboardingPageData(
            id: "benefits",
            title: "What You'll Achieve",
            body: "The 75 Progress challenge delivers transformative results that extend far beyond physical appearance.",
            bullets: [
                "Unshakeable self-discipline and mental toughness",
                "Dramatic physical transformation and improved health",
                "Enhanced focus, productivity, and goal achievement",
                "Increased confidence and self-esteem",
                "Better sleep, energy, and overall well-being"
            ],
            hashtags: ["#Results", "#Transformation"],
            showGoals: false,
            showNameInput: false,
            showConsent: false
        ),
        OnboardingPageData(
            id: "movement",
            title: "Movement & Exercise",
            body: "Physical activity is a cornerstone of the 75 Progress challenge, designed to build strength, endurance, and mental resilience.",
            bullets: [
                "Two 45-minute workouts daily (one outdoors)",
                "Mix of cardio, strength training, and flexibility",
                "Outdoor workouts build mental toughness",
                "Consistent movement improves mood and energy",
                "Track progress with daily photos"
            ],
            hashtags: ["#Movement", "#Fitness"],
            showGoals: false,
            showNameInput: false,
            showConsent: false
        ),
        OnboardingPageData(
            id: "goals",
            title: "What's Your Why?",
            body: "Choose your primary motivation for taking on the 75 Progress challenge. You can select multiple goals that resonate with you.",
            bullets: nil,
            hashtags: nil,
            showGoals: true,
            showNameInput: false,
            showConsent: false
        ),
        OnboardingPageData(
            id: "name",
            title: "Tell Us About Yourself",
            body: "Personalize your experience by sharing your name and email. This will help us track your progress and celebrate your achievements.",
            bullets: nil,
            hashtags: nil,
            showGoals: false,
            showNameInput: true,
            showConsent: false
        ),
        OnboardingPageData(
            id: "consent",
            title: "Ready to Begin?",
            body: "By starting the 75 Progress challenge, you commit to completing all daily requirements for 75 consecutive days. Are you ready to transform your life?",
            bullets: [
                "I understand the 75 Progress requirements",
                "I commit to completing all daily tasks",
                "I will track my progress honestly",
                "I'm ready to push through challenges"
            ],
            hashtags: ["#Commitment", "#Ready"],
            showGoals: false,
            showNameInput: false,
            showConsent: true
        )
    ]
}
