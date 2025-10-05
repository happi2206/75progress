//
//  Goal.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation

struct Goal: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let description: String
    let hashtag: String
    let icon: String
    
    init(id: String, title: String, description: String, hashtag: String, icon: String) {
        self.id = id
        self.title = title
        self.description = description
        self.hashtag = hashtag
        self.icon = icon
    }
}

extension Goal {
    static let allGoals: [Goal] = [
        Goal(
            id: "weight_loss",
            title: "Weight Loss",
            description: "Lose weight and get in shape",
            hashtag: "#WeightLossJourney",
            icon: "figure.walk"
        ),
        Goal(
            id: "muscle_gain",
            title: "Muscle Gain",
            description: "Build muscle and strength",
            hashtag: "#MuscleGain",
            icon: "dumbbell.fill"
        ),
        Goal(
            id: "fitness",
            title: "General Fitness",
            description: "Improve overall health and fitness",
            hashtag: "#FitnessGoals",
            icon: "heart.fill"
        ),
        Goal(
            id: "mental_health",
            title: "Mental Health",
            description: "Improve mental clarity and focus",
            hashtag: "#MentalHealth",
            icon: "brain.head.profile"
        ),
        Goal(
            id: "discipline",
            title: "Discipline",
            description: "Build self-discipline and habits",
            hashtag: "#Discipline",
            icon: "checkmark.circle.fill"
        ),
        Goal(
            id: "confidence",
            title: "Confidence",
            description: "Build self-confidence and self-esteem",
            hashtag: "#Confidence",
            icon: "star.fill"
        )
    ]
}
