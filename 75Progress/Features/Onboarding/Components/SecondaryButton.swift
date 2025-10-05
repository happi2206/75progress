//
//  SecondaryButton.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ultraThinMaterial)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(.blue.opacity(0.3), lineWidth: 1)
                        )
                )
        }
        .accessibilityLabel(title)
        .accessibilityHint("Tap to go back")
    }
}

#Preview {
    SecondaryButton(title: "Back") {}
        .padding()
}
