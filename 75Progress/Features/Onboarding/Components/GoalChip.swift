//
//  GoalChip.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct GoalChip: View {
    let goal: Goal
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: goal.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : .blue)
                
                VStack(spacing: 4) {
                    Text(goal.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isSelected ? .white : .primary)
                        .multilineTextAlignment(.center)
                    
                    Text(goal.description)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    Text(goal.hashtag)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(isSelected ? .white.opacity(0.7) : .blue)
                        .multilineTextAlignment(.center)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.blue.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel("\(goal.title) goal")
        .accessibilityHint(isSelected ? "Selected" : "Tap to select")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview {
    VStack(spacing: 16) {
        GoalChip(
            goal: Goal.allGoals[0],
            isSelected: true,
            onTap: {}
        )
        
        GoalChip(
            goal: Goal.allGoals[1],
            isSelected: false,
            onTap: {}
        )
    }
    .padding()
}
