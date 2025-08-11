//
//  SettingsViewModel.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import Foundation

class SettingsViewModel: ObservableObject {
    @Published var iCloudBackup: Bool = true
    @Published var localStorageOnly: Bool = false
    @Published var dailyReminders: Bool = true
    @Published var selectedTheme: AppTheme = .system
    @Published var showThemePicker: Bool = false
    
    init() {
        loadSettings()
    }
    
    private func loadSettings() {
        // Load saved settings from UserDefaults or other storage
        // This is a placeholder for actual implementation
    }
    
    func setReminderTime() {
        // Handle setting reminder time
        print("Set reminder time tapped")
    }
    
    func adjustTextSize() {
        // Handle text size adjustment
        print("Adjust text size tapped")
    }
    
    func exportData() {
        // Handle data export
        print("Export data tapped")
    }
    
    func clearAllData() {
        // Handle clearing all data
        print("Clear all data tapped")
    }
    
    func contactSupport() {
        // Handle contacting support
        print("Contact support tapped")
    }
}

enum AppTheme: String, CaseIterable {
    case light, dark, system
    
    var displayName: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        case .system: return "System"
        }
    }
    
    var icon: String {
        switch self {
        case .light: return "sun.max.fill"
        case .dark: return "moon.fill"
        case .system: return "gear"
        }
    }
} 