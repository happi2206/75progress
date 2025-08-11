//
//  CalendarViewModel.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Foundation

class CalendarViewModel: ObservableObject {
    @Published var currentMonth: Date = Date()
    @Published var entriesByDay: [Date: DayEntry] = [:]
    @Published var selectedDate: Date?
    
    private let coreDataManager = CoreDataManager.shared
    private let calendar = Calendar.current
    
    init() {
        // Initialize without loading data immediately to avoid Core Data issues during app startup
        // Data will be loaded when the view appears
    }
    
    // MARK: - Month Navigation
    
    func loadMonth(_ date: Date) {
        currentMonth = date
        let monthStart = calendar.dateInterval(of: .month, for: date)?.start ?? date
        let monthEnd = calendar.dateInterval(of: .month, for: date)?.end ?? date
        
        // Load entries for the entire month
        let entries = coreDataManager.fetchDayEntries(from: monthStart, to: monthEnd)
        
        // Create dictionary for quick lookup
        entriesByDay.removeAll()
        for entry in entries {
            let dayStart = calendar.startOfDay(for: entry.date)
            entriesByDay[dayStart] = entry
        }
    }
    
    func nextMonth() {
        if let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            loadMonth(nextMonth)
        }
    }
    
    func previousMonth() {
        if let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            loadMonth(previousMonth)
        }
    }
    
    // MARK: - Day Entry Management
    
    func entry(for date: Date) -> DayEntry? {
        let dayStart = calendar.startOfDay(for: date)
        return entriesByDay[dayStart]
    }
    
    func saveEntry(_ entry: DayEntry) {
        coreDataManager.saveDayEntry(entry)
        let dayStart = calendar.startOfDay(for: entry.date)
        entriesByDay[dayStart] = entry
    }
    
    func deleteEntry(for date: Date) {
        coreDataManager.deleteDayEntry(for: date)
        let dayStart = calendar.startOfDay(for: date)
        entriesByDay.removeValue(forKey: dayStart)
    }
    
    // MARK: - Completion Status
    
    func completion(for date: Date) -> Double {
        guard let entry = entry(for: date) else { return 0.0 }
        
        // Calculate completion based on photos and summary
        let photoCount = entry.photos.count
        let hasSummary = entry.summary != nil && !entry.summary!.isEmpty
        
        // For 75 Hard, typically 6 photos (progress pic, 2 workouts, reading, water, diet)
        let expectedPhotos = 6
        let photoCompletion = min(Double(photoCount) / Double(expectedPhotos), 1.0)
        let summaryCompletion = hasSummary ? 1.0 : 0.0
        
        // Weight: 80% photos, 20% summary
        return (photoCompletion * 0.8) + (summaryCompletion * 0.2)
    }
    
    // MARK: - Streak Calculation
    
    func streak(upTo date: Date) -> Int {
        var currentDate = calendar.startOfDay(for: date)
        var streak = 0
        
        while completion(for: currentDate) >= 0.8 { // 80% completion threshold
            streak += 1
            guard let previousDay = calendar.date(byAdding: .day, value: -1, to: currentDate) else {
                break
            }
            currentDate = previousDay
        }
        
        return streak
    }
    
    func currentStreak() -> Int {
        return streak(upTo: Date())
    }
    
    // MARK: - Calendar Grid Generation
    
    func daysInMonth() -> [Date?] {
        let monthStart = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let monthEnd = calendar.dateInterval(of: .month, for: currentMonth)?.end ?? currentMonth
        
        // Get the first day of the month
        let firstDayOfMonth = calendar.component(.weekday, from: monthStart)
        var leadingBlanks = firstDayOfMonth - calendar.firstWeekday
        if leadingBlanks < 0 {
            leadingBlanks += 7
        }
        
        // Get the number of days in the month
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 0
        
        var days: [Date?] = []
        
        // Add leading blanks
        for _ in 0..<leadingBlanks {
            days.append(nil)
        }
        
        // Add days of the month
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: monthStart) {
                days.append(date)
            }
        }
        
        // Add trailing blanks to complete 6 weeks (42 days)
        while days.count < 42 {
            days.append(nil)
        }
        
        return days
    }
    
    // MARK: - Share Range Calculation
    
    func dateRange(for shareType: ShareRange) -> (start: Date, end: Date) {
        let today = calendar.startOfDay(for: Date())
        
        switch shareType {
        case .today:
            return (today, today)
        case .last7Days:
            let start = calendar.date(byAdding: .day, value: -6, to: today) ?? today
            return (start, today)
        case .last30Days:
            let start = calendar.date(byAdding: .day, value: -29, to: today) ?? today
            return (start, today)
        case .full75Days:
            let start = calendar.date(byAdding: .day, value: -74, to: today) ?? today
            return (start, today)
        }
    }
    
    func entriesForRange(_ range: ShareRange) -> [DayEntry] {
        let (start, end) = dateRange(for: range)
        return coreDataManager.fetchDayEntries(from: start, to: end)
    }
}

enum ShareRange: String, CaseIterable {
    case today = "Today"
    case last7Days = "Last 7 Days"
    case last30Days = "Last 30 Days"
    case full75Days = "Full 75 Days"
} 
