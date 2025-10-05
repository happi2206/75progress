//
//  BenefitsPageView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct BenefitsPageView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("What You'll Achieve")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text("The 75 Progress challenge delivers transformative results that extend far beyond physical appearance.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach([
                    "Unshakeable self-discipline and mental toughness",
                    "Dramatic physical transformation and improved health",
                    "Enhanced focus, productivity, and goal achievement",
                    "Increased confidence and self-esteem",
                    "Better sleep, energy, and overall well-being"
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
            
            HashtagView(hashtags: ["#Results", "#Transformation"])
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    BenefitsPageView()
}
