//
//  IntroPageView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct IntroPageView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(.blue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "flame.fill")
                    .font(.system(size: 60, weight: .medium))
                    .foregroundColor(.blue)
            }
            
            VStack(spacing: 16) {
                Text("Welcome to 75 Progress")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text("Transform your life in 75 days with the ultimate challenge that builds discipline, confidence, and lasting habits.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            HashtagView(hashtags: ["#75Progress", "#Transformation"])
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    IntroPageView()
}
