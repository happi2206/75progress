//
//  ResourcesView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct ResourcesView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "book.fill")
                    .font(.system(size: 60, weight: .light))
                    .foregroundColor(.secondary)
                
                Text("Resources")
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .foregroundColor(.primary)
                
                Text("Access helpful tools and guides")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Spacer()
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ResourcesView()
} 