//
//  SettingsView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Settings")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                    
                    Text("Customize your experience")
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Privacy Settings
                SettingsSection(title: "Privacy & Storage") {
                    SettingsRow(
                        icon: "icloud",
                        title: "iCloud Backup",
                        subtitle: "Sync your data across devices",
                        isToggle: true,
                        isOn: $viewModel.iCloudBackup
                    )
                    
                    SettingsRow(
                        icon: "lock",
                        title: "Local Storage Only",
                        subtitle: "Keep data on this device only",
                        isToggle: true,
                        isOn: $viewModel.localStorageOnly
                    )
                }
                
                // Reminders
                SettingsSection(title: "Reminders") {
                    SettingsRow(
                        icon: "bell",
                        title: "Daily Reminders",
                        subtitle: "Get notified to complete tasks",
                        isToggle: true,
                        isOn: $viewModel.dailyReminders
                    )
                    
                    SettingsRow(
                        icon: "clock",
                        title: "Reminder Time",
                        subtitle: "Set when to receive reminders",
                        isToggle: false,
                        action: {
                            viewModel.setReminderTime()
                        }
                    )
                }
                
                // Appearance
                SettingsSection(title: "Appearance") {
                    SettingsRow(
                        icon: "paintbrush",
                        title: "Theme",
                        subtitle: viewModel.selectedTheme.displayName,
                        isToggle: false,
                        action: {
                            viewModel.showThemePicker = true
                        }
                    )
                    
                    SettingsRow(
                        icon: "textformat.size",
                        title: "Text Size",
                        subtitle: "Adjust app text size",
                        isToggle: false,
                        action: {
                            viewModel.adjustTextSize()
                        }
                    )
                }
                
                // Data Management
                SettingsSection(title: "Data Management") {
                    SettingsRow(
                        icon: "arrow.down.circle",
                        title: "Export Data",
                        subtitle: "Download your progress data",
                        isToggle: false,
                        action: {
                            viewModel.exportData()
                        }
                    )
                    
                    SettingsRow(
                        icon: "trash",
                        title: "Clear All Data",
                        subtitle: "Permanently delete all data",
                        isToggle: false,
                        action: {
                            viewModel.clearAllData()
                        }
                    )
                }
                
                // About
                SettingsSection(title: "About") {
                    SettingsRow(
                        icon: "info.circle",
                        title: "Version",
                        subtitle: "1.0.0",
                        isToggle: false
                    )
                    
                    SettingsRow(
                        icon: "envelope",
                        title: "Contact Support",
                        subtitle: "Get help with the app",
                        isToggle: false,
                        action: {
                            viewModel.contactSupport()
                        }
                    )
                }
                
                Spacer(minLength: 100)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showThemePicker) {
            ThemePickerView(selectedTheme: $viewModel.selectedTheme)
        }
    }
}

struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
            
            VStack(spacing: 0) {
                content
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
            )
            .padding(.horizontal, 20)
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let isToggle: Bool
    var isOn: Binding<Bool>?
    var action: (() -> Void)?
    
    init(icon: String, title: String, subtitle: String, isToggle: Bool, isOn: Binding<Bool>? = nil, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.isToggle = isToggle
        self.isOn = isOn
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isToggle {
                    Toggle("", isOn: isOn ?? .constant(false))
                        .labelsHidden()
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    SettingsView()
} 