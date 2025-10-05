//
//  WhyDaysPageView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct WhyDaysPageView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Why 75 Days?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text("Research shows that 75 days is the optimal timeframe to form lasting habits and see significant transformation in both body and mind.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach([
                    "Habit formation requires consistent repetition",
                    "Physical changes become visible after 8-12 weeks",
                    "Mental discipline strengthens with daily practice",
                    "Confidence builds through consistent achievement"
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
            
            HashtagView(hashtags: ["#Science", "#Habits"])
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    WhyDaysPageView()
}
