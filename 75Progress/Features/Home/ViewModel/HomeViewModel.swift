//
//  HomeViewModel.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Foundation
import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage


class HomeViewModel: ObservableObject {
    @Published var currentDay: Int = 14
    @Published var currentDate: Date = Date()
    @Published var progressItems: [ProgressItem] = []
    @Published var currentStreak: Int = 14
    
    // Holds the current user-provided content for each progress item
    @Published var cardContent: [UUID: ProgressCardContent] = [:]
    private let photoStorage: PhotoStorageServing = PhotoStorageService()
    private let dayLogService: DayLogServing = DayLogService()

    func uploadPhotoForToday(_ image: UIImage) {
        let forDate = currentDate
        Task { [weak self] in
            guard let self else { return }
            do {
                let uid: String
                if let current = Auth.auth().currentUser?.uid {
                    uid = current
                } else {
                    let res = try await Auth.auth().signInAnonymously()
                    uid = res.user.uid
                }

                let url = try await photoStorage.uploadProgressPhoto(image, for: forDate, uid: uid)
                try await dayLogService.appendPhotoURL(url, for: forDate, uid: uid)

            } catch {
                // surface a friendly error; keep your own toast system if you have one
                print("Upload failed:", error)
            }
        }
    }

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
    
    // MARK: - Card content updates
    func setPhoto(for itemId: UUID, _ image: UIImage) {
        // Check if it's an empty image (to clear content)
        if image.size.width == 0 || image.size.height == 0 {
            cardContent.removeValue(forKey: itemId)
        } else {
            cardContent[itemId] = .photo(image)
        }
    }
    
    func setNote(for itemId: UUID, _ text: String) {
        // Check if it's an empty string (to clear content)
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            cardContent.removeValue(forKey: itemId)
        } else {
            cardContent[itemId] = .note(text)
        }
    }
}
