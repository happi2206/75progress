//
//  ThemePickerView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct ThemePickerView: View {
    @Binding var selectedTheme: AppTheme
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Choose Theme")
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .foregroundColor(.primary)
                
                VStack(spacing: 16) {
                    ForEach(AppTheme.allCases, id: \.self) { theme in
                        ThemeOptionRow(
                            theme: theme,
                            isSelected: selectedTheme == theme
                        ) {
                            selectedTheme = theme
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
            }
            .padding(.top, 20)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold, design: .default))
                }
            }
        }
    }
}

struct ThemeOptionRow: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: theme.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.blue)
                    .frame(width: 24)
                
                Text(theme.displayName)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue.opacity(0.1) : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ThemePickerView(selectedTheme: .constant(.system))
} 