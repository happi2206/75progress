//
//  ConsentPageView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct ConsentPageView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var consentItems = [
        ConsentItem(text: "I understand the 75 Progress requirements", isChecked: false),
        ConsentItem(text: "I commit to completing all daily tasks", isChecked: false),
        ConsentItem(text: "I will track my progress honestly", isChecked: false),
        ConsentItem(text: "I'm ready to push through challenges", isChecked: false)
    ]
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Ready to Begin?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text("By starting the 75 Progress challenge, you commit to completing all daily requirements for 75 consecutive days. Are you ready to transform your life?")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            
            HashtagView(hashtags: ["#Commitment", "#Ready"])
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ConsentPageView(viewModel: OnboardingViewModel(coordinator: OnboardingCoordinator()))
}
