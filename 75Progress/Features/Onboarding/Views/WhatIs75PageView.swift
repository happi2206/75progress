//
//  WhatIs75PageView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct WhatIs75PageView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("What is 75 Progress?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text("75 Progress is a comprehensive challenge that combines physical fitness, mental development, and habit formation over 75 consecutive days.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach([
                    "Daily progress photos to track your transformation",
                    "Two 45-minute workouts (one must be outdoors)",
                    "Follow a strict diet with no cheat meals",
                    "Read 10 pages of a non-fiction book daily",
                    "Drink 1 gallon of water every day"
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
            
            HashtagView(hashtags: ["#75Hard", "#Challenge"])
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    WhatIs75PageView()
}
