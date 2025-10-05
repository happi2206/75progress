//
//  HomeView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var daySummary: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text("75 Hard")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                  
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                // Reflection Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Reflection")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    Text("Day \(viewModel.currentDay), \(viewModel.formattedDate)")
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // Streak Counter
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Current Streak")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.secondary)
                        
                        HStack(spacing: 8) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.orange)
                            
                            Text("\(viewModel.currentStreak) days")
                                .font(.system(size: 18, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.shareProgress()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14, weight: .medium))
                            Text("Share")
                                .font(.system(size: 14, weight: .medium, design: .default))
                        }
                        .foregroundColor(.blue)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.blue.opacity(0.1))
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                // Progress Cards Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 16) {
                    ForEach(viewModel.progressItems) { item in
                        ProgressCard(
                            item: item,
                            content: viewModel.cardContent[item.id],
                            onPhoto: { image in
                                viewModel.setPhoto(for: item.id, image)
                                viewModel.uploadPhotoForToday(image)
                            },
                            onNote: { text in
                                viewModel.setNote(for: item.id, text)
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
                
                // Day Summary
                VStack(alignment: .leading, spacing: 12) {
                    Text("Day Summary")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    TextField("Write your daily reflection here...", text: $daySummary, axis: .vertical)
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.primary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                        .lineLimit(4...8)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 100) // Add bottom padding for tab bar
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    HomeView()
} 
