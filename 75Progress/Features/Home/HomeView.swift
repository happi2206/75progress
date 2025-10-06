//
//  HomeView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @StateObject private var calendarShareViewModel = CalendarViewModel()
    @State private var showSavedSheet = false
    @State private var showShareSheet = false
    @State private var isSaving = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                header
                progressGrid
            }
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSavedSheet) {
            SavedCelebration(viewModel: viewModel) {
                calendarShareViewModel.loadMonth(viewModel.currentDate)
                showShareSheet = true
            }
        }
        .sheet(isPresented: $showShareSheet) {
            SharePickerView(viewModel: calendarShareViewModel)
        }
        .onAppear {
            calendarShareViewModel.loadMonth(viewModel.currentDate)
        }
        .onChange(of: viewModel.currentDate) { newDate in
            calendarShareViewModel.loadMonth(newDate)
        }
    }
}

private extension HomeView {
    var header: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Reflection")
                        .font(.system(size: 13, weight: .semibold, design: .default))
                        .foregroundColor(.secondary)
                    Text("Day \(viewModel.dayNumber)")
                        .font(.system(size: 22, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                    Text(viewModel.currentDate.longWithOrdinal)
                        .font(.system(size: 15, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                }
                Spacer()
                shareButton
            }

            HStack(spacing: 16) {
                navButton(icon: "chevron.left", enabled: viewModel.canShowPreviousDay) {
                    viewModel.showPreviousDay()
                }

                Spacer(minLength: 8)

                logToggle

                Spacer(minLength: 8)

                navButton(icon: "chevron.right", enabled: viewModel.canShowNextDay) {
                    viewModel.showNextDay()
                }
            }

            Divider()
                .background(Color.white.opacity(0.2))

            Label {
                Text(viewModel.currentStreakText)
                    .font(.system(size: 16, weight: .semibold, design: .default))
            } icon: {
                Image(systemName: "flame.fill")
                    .symbolRenderingMode(.multicolor)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(
                Capsule()
                    .fill(Color.orange.opacity(0.12))
            )
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.accentColor.opacity(0.18),
                            Color.purple.opacity(0.08)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(Color.white.opacity(0.25), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.top, 24)
        .padding(.bottom, 24)
    }
    
    var shareButton: some View {
        Button {
            calendarShareViewModel.loadMonth(viewModel.currentDate)
            showShareSheet = true
        } label: {
            Label("Share", systemImage: "square.and.arrow.up")
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(Color.accentColor.opacity(0.15))
                )
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.accentColor)
    }
    
    var logToggle: some View {
        Toggle(isOn: logToggleBinding) {
            HStack(spacing: 8) {
                Text(viewModel.isCurrentDayComplete ? "Logged" : "Log day")
                    .font(.system(size: 14, weight: .semibold))
                if isSaving {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(0.65)
                }
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: .accentColor))
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground).opacity(0.7))
        )
        .disabled(isSaving)
    }

    var logToggleBinding: Binding<Bool> {
        Binding(
            get: { viewModel.isCurrentDayComplete },
            set: { newValue in
                guard newValue != viewModel.isCurrentDayComplete else { return }
                guard !isSaving else { return }
                isSaving = true
                Task {
                    await viewModel.setDayLogged(newValue)
                    await MainActor.run {
                        isSaving = false
                        if newValue {
                            showSavedSheet = true
                        }
                    }
                }
            }
        )
    }
    
    var progressGrid: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Daily Tasks")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)

            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 16) {
                ForEach(viewModel.progressItems) { item in
                        ProgressCard(
                            item: item,
                            content: viewModel.content(for: item),
                        onPhoto: { progressItem, image in
                            viewModel.setPhoto(for: progressItem, image)
                        },
                        onNote: { progressItem, text in
                            viewModel.setNote(for: progressItem, text)
                        }
                        )
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(.systemBackground).opacity(0.75))
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
    
    var summarySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Day Summary")
                .font(.system(size: 18, weight: .semibold, design: .default))
                .foregroundColor(.primary)
            
            TextField("Write your daily reflection here...", text: $viewModel.daySummary, axis: .vertical)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundColor(.primary)
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.systemBackground).opacity(0.6))
                )
                .lineLimit(4...8)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(Color(.systemBackground).opacity(0.75))
                .overlay(
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .stroke(Color.primary.opacity(0.05), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
        .padding(.bottom, 40)
    }

    func navButton(icon: String, enabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .frame(width: 36, height: 36)
                .background(
                    Circle()
                        .fill(enabled ? Color.accentColor.opacity(0.18) : Color(.systemFill))
                )
                .foregroundStyle(enabled ? Color.accentColor : Color.secondary)
        }
        .buttonStyle(.plain)
        .disabled(!enabled)
        .opacity(enabled ? 1 : 0.4)
    }
}

#Preview {
    HomeView()
}
