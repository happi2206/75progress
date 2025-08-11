//
//  ProfileView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showSettings = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(spacing: 16) {
                        // Profile Image
                        ZStack {
                            Circle()
                                .fill(.blue.opacity(0.1))
                                .frame(width: 100, height: 100)
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 40, weight: .medium))
                                .foregroundColor(.blue)
                        }
                        
                        VStack(spacing: 4) {
                            Text(viewModel.userProfile.name)
                                .font(.system(size: 24, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                            
                            Text(viewModel.userProfile.email)
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Settings Button
                    Button(action: {
                        showSettings = true
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primary)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                            )
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                // Stats Cards
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    StatCard(title: "Current Streak", value: "\(viewModel.userProfile.currentStreak)", icon: "flame.fill", color: .orange)
                    StatCard(title: "Total Days", value: "\(viewModel.userProfile.totalDays)", icon: "calendar", color: .blue)
                    StatCard(title: "Challenges", value: "\(viewModel.userProfile.completedChallenges)", icon: "trophy.fill", color: .yellow)
                }
                .padding(.horizontal, 20)
                
                // Current Challenge
                VStack(alignment: .leading, spacing: 16) {
                    Text("Current Challenge")
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    ChallengeCard(challenge: viewModel.currentChallenge)
                }
                .padding(.horizontal, 20)
                
                // Milestones
                VStack(alignment: .leading, spacing: 16) {
                    Text("Milestones")
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(viewModel.milestones) { milestone in
                            MilestoneCard(milestone: milestone)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.editProfile()
                    }) {
                        HStack {
                            Image(systemName: "person.circle")
                                .font(.system(size: 18, weight: .medium))
                            Text("Edit Profile")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                    }
                    
                    Button(action: {
                        viewModel.createNewChallenge()
                    }) {
                        HStack {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 18, weight: .medium))
                            Text("Create New Challenge")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .foregroundColor(.primary)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 100)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .medium))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(size: 20, weight: .bold, design: .default))
                .foregroundColor(.primary)
            
            Text(title)
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct ChallengeCard: View {
    let challenge: Challenge
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(challenge.name)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    Text("Day \(challenge.currentDay) of \(challenge.totalDays)")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                CircularProgressView(progress: Double(challenge.currentDay) / Double(challenge.totalDays))
            }
            
            ProgressView(value: Double(challenge.currentDay), total: Double(challenge.totalDays))
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct MilestoneCard: View {
    let milestone: Milestone
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: milestone.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(milestone.isCompleted ? .green : .secondary)
                
                Text(milestone.title)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.primary)
                
                Spacer()
            }
            
            Text(milestone.description)
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.secondary.opacity(0.2), lineWidth: 4)
                .frame(width: 40, height: 40)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 40, height: 40)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)
        }
    }
}

#Preview {
    ProfileView()
} 