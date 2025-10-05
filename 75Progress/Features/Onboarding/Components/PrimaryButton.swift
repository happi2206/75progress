//
//  PrimaryButton.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let isLoading: Bool
    let isEnabled: Bool
    let action: () -> Void
    
    init(
        title: String,
        isLoading: Bool = false,
        isEnabled: Bool = true,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.isLoading = isLoading
        self.isEnabled = isEnabled
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isEnabled ? Color.blue : Color.gray)
            )
        }
        .disabled(!isEnabled || isLoading)
        .accessibilityLabel(title)
        .accessibilityHint(isEnabled ? "Tap to continue" : "Button disabled")
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(
            title: "Continue",
            isLoading: false,
            isEnabled: true,
            action: {}
        )
        
        PrimaryButton(
            title: "Loading...",
            isLoading: true,
            isEnabled: true,
            action: {}
        )
        
        PrimaryButton(
            title: "Disabled",
            isLoading: false,
            isEnabled: false,
            action: {}
        )
    }
    .padding()
}
