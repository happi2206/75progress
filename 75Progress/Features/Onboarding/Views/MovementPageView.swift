//
//  MovementPageView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct MovementPageView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Movement & Exercise")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text("Physical activity is a cornerstone of the 75 Progress challenge, designed to build strength, endurance, and mental resilience.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach([
                    "Two 45-minute workouts daily (one outdoors)",
                    "Mix of cardio, strength training, and flexibility",
                    "Outdoor workouts build mental toughness",
                    "Consistent movement improves mood and energy",
                    "Track progress with daily photos"
                ], id: \.self) { bullet in
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                            .padding(.top, 2)
                        
                        Text(bullet)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 20)
            
            HashtagView(hashtags: ["#Movement", "#Fitness"])
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MovementPageView()
}
