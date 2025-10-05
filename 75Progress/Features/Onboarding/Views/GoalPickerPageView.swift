//
//  GoalPickerPageView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct GoalPickerPageView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("What's Your Why?")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text("Choose your primary motivation for taking on the 75 Progress challenge. You can select multiple goals that resonate with you.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(Goal.allGoals, id: \.id) { goal in
                    GoalChip(
                        goal: goal,
                        isSelected: viewModel.isGoalSelected(goal.id)
                    ) {
                        viewModel.toggleGoal(goal.id)
                    }
                }
            }
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Goal selection")
            
            if viewModel.state.selectedGoals.isEmpty {
                Text("Select at least one goal to continue")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.orange)
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    GoalPickerPageView(viewModel: OnboardingViewModel(coordinator: OnboardingCoordinator()))
}
