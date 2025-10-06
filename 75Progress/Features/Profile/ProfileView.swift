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
        ZStack {
            ScrollView {
                VStack(spacing: 24) {
                    profileHeader
                    statSection
                    challengeSection
                    goalsSection
                    milestonesSection
                }
                .padding(.bottom, 40)
            }
            .background(Color(uiColor: .systemGroupedBackground))

            if viewModel.isLoading {
                Color.black.opacity(0.05)
                    .ignoresSafeArea()
                ProgressView()
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
        }
        .sheet(isPresented: $viewModel.showEditNameSheet) {
            EditNameSheet(
                name: $viewModel.editedName,
                isLoading: viewModel.isLoading,
                errorMessage: viewModel.updateError,
                onCancel: { viewModel.showEditNameSheet = false },
                onSave: viewModel.saveEditedName
            )
            .presentationDetents([.height(260)])
        }
    }
}

private extension ProfileView {
    var profileHeader: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.accentColor.opacity(0.2), Color.blue.opacity(0.15)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(Color.white.opacity(0.4), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center, spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.35))
                            .frame(width: 74, height: 74)
                        Image(systemName: "person.fill")
                            .font(.system(size: 34, weight: .medium))
                            .foregroundColor(Color.accentColor)
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(viewModel.userProfile.displayName ?? viewModel.userProfile.name)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.primary)
                        Text(viewModel.userProfile.email.isEmpty ? "No email on record" : viewModel.userProfile.email)
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button {
                        viewModel.editProfile()
                    } label: {
                        Image(systemName: "pencil")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.accentColor)
                            .padding(10)
                            .background(Circle().fill(Color.white.opacity(0.6)))
                    }
                    .buttonStyle(.plain)
                }

                Button {
                    showSettings = true
                } label: {
                    Label("Preferences", systemImage: "gearshape.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Capsule().fill(Color.white.opacity(0.6)))
                }
                .buttonStyle(.plain)
            }
            .padding(24)
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }

    var statSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Quick Stats")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)

            HStack(spacing: 6) {
                StatCard(title: "Streak", value: "\(viewModel.userProfile.currentStreak)", icon: "flame.fill", color: .orange)
                StatCard(title: "Total Days", value: "\(viewModel.userProfile.totalDays)", icon: "calendar", color: .blue)
            }
        }
        .padding(.horizontal, 20)
    }

    var challengeSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Current Challenge")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)

            ChallengeCard(challenge: viewModel.currentChallenge)
        }
        .padding(.horizontal, 20)
    }

    var goalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Focus Goals")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)

            if viewModel.goals.isEmpty {
                Text("No goals selected yet. Head to onboarding to pick your focus.")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.secondary)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
            } else {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                    ForEach(viewModel.goals, id: \.self) { goal in
                        Text(goal.replacingOccurrences(of: "_", with: " ").capitalized)
                            .font(.system(size: 13, weight: .semibold))
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color.accentColor.opacity(0.18))
                            )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }

    var milestonesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Milestones")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(viewModel.milestones) { milestone in
                    MilestoneCard(milestone: milestone)
                }
            }
        }
        .padding(.horizontal, 20)
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
        .frame(maxWidth: .infinity)
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

struct EditNameSheet: View {
    @Binding var name: String
    let isLoading: Bool
    let errorMessage: String?
    let onCancel: () -> Void
    let onSave: () -> Void

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Display Name")
                    .font(.headline)
                TextField("Enter your name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.words)

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                }

                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", action: onCancel)
                        .fontWeight(.semibold)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save", action: onSave)
                        .fontWeight(.semibold)
                        .disabled(isLoading)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
        }
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
