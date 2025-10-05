//
//  OnboardingContainerView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel: OnboardingViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(coordinator: OnboardingCoordinator) {
        self._viewModel = StateObject(wrappedValue: OnboardingViewModel(coordinator: coordinator))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Progress indicator
                    ProgressIndicator(
                        currentPage: viewModel.state.currentPage,
                        totalPages: OnboardingPageData.pages.count
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Page content
                    TabView(selection: $viewModel.state.currentPage) {
                        ForEach(Array(OnboardingPageData.pages.enumerated()), id: \.offset) { index, pageData in
                            OnboardingPageView(
                                pageData: pageData,
                                viewModel: viewModel
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.3), value: viewModel.state.currentPage)
                    
                    // Navigation buttons
                    NavigationButtons(viewModel: viewModel)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
        }
        .toast()
    }
}

struct ProgressIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index <= currentPage ? Color.blue : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
            }
        }
        .accessibilityLabel("Page \(currentPage + 1) of \(totalPages)")
    }
}

struct NavigationButtons: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        HStack(spacing: 16) {
            if viewModel.state.currentPage > 0 {
                SecondaryButton(title: "Back") {
                    viewModel.previousPage()
                }
            } else {
                Spacer()
            }
            
            PrimaryButton(
                title: viewModel.isLastPage ? "Start Challenge" : "Next",
                isLoading: viewModel.isLoading,
                isEnabled: viewModel.canProceed
            ) {
                viewModel.nextPage()
            }
        }
    }
}

#Preview {
    OnboardingContainerView(coordinator: OnboardingCoordinator())
}
