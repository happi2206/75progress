//
//  OnboardingPageView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct OnboardingPageView: View {
    let pageData: OnboardingPageData
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                Spacer(minLength: 40)
                
                // Title
                Text(pageData.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                // Body text
                Text(pageData.body)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                
                // Bullets
                if let bullets = pageData.bullets {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(bullets, id: \.self) { bullet in
                            HStack(alignment: .top, spacing: 12) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.blue)
                                    .padding(.top, 2)
                                
                                Text(bullet)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.primary)
                                    .multilineTextAlignment(.leading)
                                
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                // Goals selection
                if pageData.showGoals {
                    GoalSelectionView(viewModel: viewModel)
                }
                
                // Name input
                if pageData.showNameInput {
                    NameInputView(viewModel: viewModel)
                }
                
                // Consent checkboxes
                if pageData.showConsent {
                    ConsentView(viewModel: viewModel)
                }
                
                // Hashtags
                if let hashtags = pageData.hashtags {
                    HashtagView(hashtags: hashtags)
                }
                
                Spacer(minLength: 40)
            }
            .padding(.horizontal, 20)
        }
    }
}

struct GoalSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 16) {
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
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Goal selection")
    }
}

struct NameInputView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, email
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Name Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Name")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                TextField("Enter your name", text: $viewModel.state.displayName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .focused($focusedField, equals: .name)
                    .onChange(of: viewModel.state.displayName) { _, newValue in
                        viewModel.updateDisplayName(newValue)
                    }
                    .accessibilityLabel("Name input field")
                    .accessibilityHint("Enter your name to personalize your experience")
                
                if !viewModel.state.displayName.isEmpty && !viewModel.validateName(viewModel.state.displayName) {
                    Text("Name must be 2-24 characters, letters and spaces only")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red)
                }
            }
            
            // Email Input
            VStack(alignment: .leading, spacing: 8) {
                Text("Email")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                
                TextField("Enter your email", text: $viewModel.state.email)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .email)
                    .onChange(of: viewModel.state.email) { _, newValue in
                        viewModel.updateEmail(newValue)
                    }
                    .accessibilityLabel("Email input field")
                    .accessibilityHint("Enter your email address")
                
                if !viewModel.state.email.isEmpty && !viewModel.validateEmail(viewModel.state.email) {
                    Text("Please enter a valid email address")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            focusedField = .name
        }
    }
}

struct ConsentView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var consentItems = [
        ConsentItem(text: "I understand the 75 Progress requirements", isChecked: false),
        ConsentItem(text: "I commit to completing all daily tasks", isChecked: false),
        ConsentItem(text: "I will track my progress honestly", isChecked: false),
        ConsentItem(text: "I'm ready to push through challenges", isChecked: false)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(consentItems.indices, id: \.self) { index in
                HStack(alignment: .top, spacing: 12) {
                    Button(action: {
                        consentItems[index].isChecked.toggle()
                    }) {
                        Image(systemName: consentItems[index].isChecked ? "checkmark.square.fill" : "square")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(consentItems[index].isChecked ? .blue : .gray)
                    }
                    .accessibilityLabel(consentItems[index].text)
                    .accessibilityHint(consentItems[index].isChecked ? "Checked" : "Unchecked")
                    
                    Text(consentItems[index].text)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
        }
    }
}

struct HashtagView: View {
    let hashtags: [String]
    
    var body: some View {
        HStack {
            ForEach(hashtags, id: \.self) { hashtag in
                Text(hashtag)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue.opacity(0.1))
                    )
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Hashtags: \(hashtags.joined(separator: ", "))")
    }
}

struct ConsentItem {
    let text: String
    var isChecked: Bool
}

#Preview {
    OnboardingPageView(
        pageData: OnboardingPageData.pages[0],
        viewModel: OnboardingViewModel(coordinator: OnboardingCoordinator())
    )
}
