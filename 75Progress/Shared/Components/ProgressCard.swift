//
//  ProgressCard.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct ProgressCard: View {
    let item: ProgressItem
    
    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(item.color.opacity(0.1))
                    .frame(height: 120)
                
                Image(systemName: item.iconName)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(item.color)
            }
            
            // Title
            Text(item.title)
                .font(.system(size: 14, weight: .medium, design: .default))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }
}

#Preview {
    ProgressCard(item: ProgressItem(
        title: "Workout",
        iconName: "dumbbell.fill",
        color: .orange
    ))
    .padding()
} 