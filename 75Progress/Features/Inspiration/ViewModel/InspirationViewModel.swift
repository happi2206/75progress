//
//  InspirationViewModel.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Foundation

class InspirationViewModel: ObservableObject {
    @Published var dailyQuote: Quote
    @Published var recommendedBooks: [Book] = []
    @Published var workoutSuggestions: [WorkoutSuggestion] = []
    
    init() {
        self.dailyQuote = Quote(
            text: "The only person you should try to be better than is the person you were yesterday.",
            author: "Andy Frisella"
        )
        setupRecommendedBooks()
        setupWorkoutSuggestions()
    }
    
    private func setupRecommendedBooks() {
        recommendedBooks = [
            Book(title: "75 Hard", author: "Andy Frisella"),
            Book(title: "Atomic Habits", author: "James Clear"),
            Book(title: "Can't Hurt Me", author: "David Goggins"),
            Book(title: "The Power of Now", author: "Eckhart Tolle"),
            Book(title: "Mindset", author: "Carol S. Dweck")
        ]
    }
    
    private func setupWorkoutSuggestions() {
        workoutSuggestions = [
            WorkoutSuggestion(
                title: "Morning Cardio",
                duration: "30 min",
                icon: "heart.fill",
                color: .red
            ),
            WorkoutSuggestion(
                title: "Strength Training",
                duration: "45 min",
                icon: "dumbbell.fill",
                color: .orange
            ),
            WorkoutSuggestion(
                title: "Yoga Flow",
                duration: "20 min",
                icon: "figure.mind.and.body",
                color: .purple
            ),
            WorkoutSuggestion(
                title: "HIIT Circuit",
                duration: "25 min",
                icon: "timer",
                color: .green
            )
        ]
    }
    
    func refreshDailyQuote() {
        // In a real app, this would fetch from an API
        let quotes = [
            Quote(text: "Discipline is choosing between what you want now and what you want most.", author: "Andy Frisella"),
            Quote(text: "The only way to get better is to get uncomfortable.", author: "Andy Frisella"),
            Quote(text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill"),
            Quote(text: "The difference between the impossible and the possible lies in determination.", author: "Tommy Lasorda")
        ]
        
        dailyQuote = quotes.randomElement() ?? dailyQuote
    }
} 