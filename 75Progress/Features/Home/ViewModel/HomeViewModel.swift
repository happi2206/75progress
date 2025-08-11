//
//  HomeViewModel.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Foundation

class HomeViewModel: ObservableObject {
    @Published var currentDay: Int = 14
    @Published var currentDate: Date = Date()
    @Published var progressItems: [ProgressItem] = []
    @Published var currentStreak: Int = 14
    
    init() {
        setupProgressItems()
    }
    
    private func setupProgressItems() {
        progressItems = [
            ProgressItem(title: "Progress Pic", iconName: "person.fill", color: .blue),
            ProgressItem(title: "Workout 1", iconName: "dumbbell.fill", color: .orange),
            ProgressItem(title: "Workout 2", iconName: "figure.strengthtraining.traditional", color: .green),
            ProgressItem(title: "Reading", iconName: "book.fill", color: .purple),
            ProgressItem(title: "Water", iconName: "drop.fill", color: .cyan),
            ProgressItem(title: "Diet", iconName: "leaf.fill", color: .mint)
        ]
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE d'nd' 'of' MMMM"
        return formatter.string(from: currentDate)
    }
    
    func addNewEntry() {
        // Handle adding new entry
        print("Add new entry tapped")
    }
    
    func shareProgress() {
        // Handle sharing progress
        print("Share progress tapped")
    }
    
    func updateStreak() {
        currentStreak += 1
    }
    
    func resetStreak() {
        currentStreak = 0
    }
}
