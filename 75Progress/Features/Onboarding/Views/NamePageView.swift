//
//  NamePageView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct NamePageView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @FocusState private var focusedField: Field?
    
    enum Field {
        case name, email
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Tell Us About Yourself")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .accessibilityAddTraits(.isHeader)
                
                Text("Personalize your experience by sharing your name and email. This will help us track your progress and celebrate your achievements.")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
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
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear {
            focusedField = .name
        }
    }
}

#Preview {
    NamePageView(viewModel: OnboardingViewModel(coordinator: OnboardingCoordinator()))
}
