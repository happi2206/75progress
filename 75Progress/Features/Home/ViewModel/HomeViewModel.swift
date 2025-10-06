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

class HomeViewModel: ObservableObject {
    @Published var dayNumber: Int = 1
    @Published var currentDate: Date = Date()
    @Published var progressItems: [ProgressItem] = []
    @Published var currentStreak: Int = 0
    @Published var daySummary: String = ""
    @Published var cardContent: [String: ProgressCardContent] = [:]
    @Published var isCurrentDayComplete: Bool = false
    
    private let photoStorage: PhotoStorageServing = PhotoStorageService()
    private let dayLogService: DayLogServing = DayLogService()
    private let calendar = Calendar.current
    private var cachedCardContent: [Date: [String: ProgressCardContent]] = [:]
    private var cachedSummaries: [Date: String] = [:]
    private var cachedCompletion: [Date: Bool] = [:]
    private var photoURLsByDay: [Date: [String: URL]] = [:]
    private var earliestEntryDate: Date?
    private var challengeStartDate: Date {
        didSet {
            UserDefaults.standard.set(challengeStartDate, forKey: "challengeStartDate")
        }
    }
    
    @MainActor
    init() {
        let today = calendar.startOfDay(for: Date())
        currentDate = today
        challengeStartDate = calendar.startOfDay(for: UserDefaults.standard.object(forKey: "challengeStartDate") as? Date ?? today)
        setupProgressItems()
        earliestEntryDate = CoreDataManager.shared.earliestDayEntryDate()
        if let earliest = earliestEntryDate, earliest < challengeStartDate {
            challengeStartDate = calendar.startOfDay(for: earliest)
        }
        updateState(for: currentDate)
        recalculateProgressMetrics()
    }
    
    var currentStreakText: String {
        let suffix = currentStreak == 1 ? "day" : "days"
        return "\(currentStreak) \(suffix)"
    }
    
    var canShowPreviousDay: Bool {
        normalized(currentDate) > earliestNavigableDate
    }
    
    var canShowNextDay: Bool {
        normalized(currentDate) < normalized(Date())
    }
    
    @MainActor
    func showPreviousDay() {
        guard canShowPreviousDay,
              let newDate = calendar.date(byAdding: .day, value: -1, to: currentDate) else { return }
        persistCurrentDaySnapshot()
        updateState(for: newDate)
    }

    @MainActor
    func showNextDay() {
        guard canShowNextDay,
              let newDate = calendar.date(byAdding: .day, value: 1, to: currentDate) else { return }
        persistCurrentDaySnapshot()
        updateState(for: newDate)
    }
    
    private func setupProgressItems() {
        progressItems = [
            ProgressItem(title: "Progress Pic", iconName: "person.fill", color: .blue, storageKey: "progress_pic"),
            ProgressItem(title: "Workout 1", iconName: "dumbbell.fill", color: .orange, storageKey: "workout_1"),
            ProgressItem(title: "Workout 2", iconName: "figure.strengthtraining.traditional", color: .green, storageKey: "workout_2"),
            ProgressItem(title: "Reading", iconName: "book.fill", color: .purple, storageKey: "reading"),
            ProgressItem(title: "Water", iconName: "drop.fill", color: .cyan, storageKey: "water"),
            ProgressItem(title: "Diet", iconName: "leaf.fill", color: .mint, storageKey: "diet")
        ]
    }

    func content(for item: ProgressItem) -> ProgressCardContent? {
        cardContent[item.storageKey]
    }

    // MARK: - Card content updates
    func setPhoto(for item: ProgressItem, _ image: UIImage) {
        let key = normalized(currentDate)
        let storageKey = item.storageKey
        if image.size.width == 0 || image.size.height == 0 {
            cardContent.removeValue(forKey: storageKey)
            cachedCardContent[key] = cardContent
            var map = photoURLsByDay[key] ?? [:]
            map.removeValue(forKey: storageKey)
            photoURLsByDay[key] = map
            updateDayEntryPhotos(for: key)
            Task { [weak self] in
                guard let self else { return }
                do {
                    let uid = try await self.ensureCurrentUser()
                    try await self.dayLogService.removePhoto(for: storageKey, date: key, uid: uid)
                } catch {
                    print("Failed to remove photo:", error)
                }
            }
        } else {
            cardContent[storageKey] = .photo(image)
            cachedCardContent[key] = cardContent
            uploadPhotoForToday(image, for: item)
        }
    }

    func setNote(for item: ProgressItem, _ text: String) {
        let key = normalized(currentDate)
        let storageKey = item.storageKey
        if text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            cardContent.removeValue(forKey: storageKey)
        } else {
            cardContent[storageKey] = .note(text)
        }
        cachedCardContent[key] = cardContent
    }

    func uploadPhotoForToday(_ image: UIImage, for item: ProgressItem) {
        guard image.size.width > 0, image.size.height > 0 else { return }
        let forDate = normalized(currentDate)
        let storageKey = item.storageKey
        Task { [weak self] in
            guard let self else { return }
            do {
                let uid = try await self.ensureCurrentUser()
                let url = try await self.photoStorage.uploadProgressPhoto(image, for: forDate, uid: uid)
                try await self.dayLogService.setPhotoURL(url, for: storageKey, date: forDate, uid: uid)
                await MainActor.run {
                    var map = self.photoURLsByDay[forDate] ?? [:]
                    map[storageKey] = url
                    self.photoURLsByDay[forDate] = map
                    if self.isCurrentDayComplete && self.normalized(self.currentDate) == forDate {
                        self.updateDayEntryPhotos(for: forDate)
                    }
                }
            } catch {
                print("Upload failed:", error)
            }
        }
    }

    @MainActor
    func setDayLogged(_ isLogged: Bool) async {
        let manager = CoreDataManager.shared
        let day = normalized(currentDate)
        var entry = manager.fetchDayEntry(for: day) ?? DayEntry(date: day)

        cachedCardContent[day] = cardContent
        cachedSummaries[day] = daySummary
        cachedCompletion[day] = isLogged
        let trimmedSummary = daySummary.trimmingCharacters(in: .whitespacesAndNewlines)
        entry.summary = trimmedSummary.isEmpty ? nil : trimmedSummary
        entry.isComplete = isLogged
        entry.photos = isLogged ? photoItems(for: day) : []
        entry.notes = notesDictionary(for: day)

        manager.saveDayEntry(entry)
        daySummary = entry.summary ?? ""
        isCurrentDayComplete = isLogged
        recalculateProgressMetrics()
        updateDayNumber(for: day)
        if earliestEntryDate == nil || day < earliestEntryDate! {
            earliestEntryDate = day
        }
        if day < challengeStartDate {
            challengeStartDate = day
        }

        NotificationCenter.default.post(
            name: .dayProgressSaved,
            object: nil,
            userInfo: ["currentStreak": currentStreak]
        )

        do {
            let uid = try await ensureCurrentUser()
            try await dayLogService.upsertDayLog(for: day, uid: uid, summary: entry.summary, isComplete: isLogged, streak: currentStreak)
        } catch {
            print("Day log sync failed:", error)
        }
    }

    @MainActor
    private func updateState(for date: Date) {
        let normalizedDate = normalized(date)
        currentDate = normalizedDate
        loadEntry(for: normalizedDate)
        updateDayNumber(for: normalizedDate)
    }
    
    @MainActor
    private func loadEntry(for date: Date) {
        let key = normalized(date)
        let entry = CoreDataManager.shared.fetchDayEntry(for: key)

        if let entry {
            photoURLsByDay[key] = storageMap(from: entry.photos)
        }

        if let entryDate = entry?.date {
            if earliestEntryDate == nil || normalized(entryDate) < earliestEntryDate! {
                earliestEntryDate = normalized(entryDate)
            }
        }

        if let cached = cachedSummaries[key] {
            daySummary = cached
        } else if let entry {
            daySummary = entry.summary ?? ""
            cachedSummaries[key] = daySummary
        } else {
            daySummary = ""
        }

        if let cached = cachedCompletion[key] {
            isCurrentDayComplete = cached
        } else if let entry {
            isCurrentDayComplete = entry.isComplete
            cachedCompletion[key] = entry.isComplete
        } else {
            isCurrentDayComplete = false
        }

        cardContent = cachedCardContent[key] ?? [:]
        fetchRemotePhotos(for: key)
    }

    @MainActor
    private func recalculateProgressMetrics() {
        let manager = CoreDataManager.shared
        var streak = 0
        var cursor = normalized(Date())

        while let entry = manager.fetchDayEntry(for: cursor), entry.isComplete {
            streak += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = previous
        }

        currentStreak = streak
        DayStreak.shared.update(with: streak)
    }

    private func updateDayNumber(for date: Date) {
        if let recordedEarliest = CoreDataManager.shared.earliestDayEntryDate() {
            earliestEntryDate = recordedEarliest
            if recordedEarliest < challengeStartDate {
                challengeStartDate = calendar.startOfDay(for: recordedEarliest)
            }
        }

        let start = challengeStartDate
        let diff = calendar.dateComponents([.day], from: start, to: date).day ?? 0
        dayNumber = max(diff + 1, 1)
    }

    private func ensureCurrentUser() async throws -> String {
        if let current = Auth.auth().currentUser?.uid {
            return current
        }
        let result = try await Auth.auth().signInAnonymously()
        return result.user.uid
    }

    private func normalized(_ date: Date) -> Date {
        calendar.startOfDay(for: date)
    }

    private var earliestNavigableDate: Date {
        let seventyFiveDaysAgo = calendar.date(byAdding: .day, value: -74, to: normalized(Date())) ?? normalized(Date())
        var earliest = challengeStartDate
        if let entry = earliestEntryDate {
            earliest = min(earliest, normalized(entry))
        }
        return max(earliest, seventyFiveDaysAgo)
    }

    private func persistCurrentDaySnapshot() {
        let key = normalized(currentDate)
        cachedSummaries[key] = daySummary
        cachedCompletion[key] = isCurrentDayComplete
        cachedCardContent[key] = cardContent
    }

    private func fetchRemotePhotos(for date: Date) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let uid = try await self.ensureCurrentUser()
                let remoteMap = try await self.dayLogService.fetchPhotoURLs(for: date, uid: uid)
                var updated = self.cachedCardContent[date] ?? [:]

                for (itemKey, url) in remoteMap {
                    if case .photo = updated[itemKey] { continue }
                    if let image = await self.loadImage(from: url) {
                        updated[itemKey] = .photo(image)
                    }
                }

                await MainActor.run { [weak self] in
                    guard let self else { return }
                    self.cachedCardContent[date] = updated
                    self.photoURLsByDay[date] = remoteMap
                    self.updateDayEntryPhotos(for: date)
                    if self.normalized(self.currentDate) == date {
                        self.cardContent = updated
                    }
                }
            } catch {
                print("Failed to fetch remote photos:", error)
            }
        }
    }

    private func photoItems(for date: Date) -> [PhotoItem] {
        let map = photoURLsByDay[date] ?? [:]
        return map.compactMap { key, url in
            guard let item = progressItems.first(where: { $0.storageKey == key }) else { return nil }
            return PhotoItem(url: url, label: item.title)
        }
    }

    private func notesDictionary(for date: Date) -> [UUID: String] {
        let source = cachedCardContent[date] ?? [:]
        var result: [UUID: String] = [:]
        for (_, content) in source {
            if case .note(let text) = content, !text.isEmpty {
                result[UUID()] = text
            }
        }
        return result
    }

    private func storageMap(from photos: [PhotoItem]) -> [String: URL] {
        var map: [String: URL] = [:]
        for photo in photos {
            if let item = progressItems.first(where: { $0.title == photo.label }) {
                map[item.storageKey] = photo.url
            }
        }
        return map
    }

    private func updateDayEntryPhotos(for date: Date) {
        let manager = CoreDataManager.shared
        guard var entry = manager.fetchDayEntry(for: date) else { return }
        entry.photos = photoItems(for: date)
        manager.saveDayEntry(entry)
    }

    private func loadImage(from url: URL) async -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Image download failed for URL \(url):", error)
            return nil
        }
    }
}
