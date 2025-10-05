//
//  ProgressCard.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI
import UIKit

struct ProgressCard: View {
    let item: ProgressItem
    let content: ProgressCardContent?
    let onPhoto: (UIImage) -> Void
    let onNote: (String) -> Void
    @State private var showingActionSheet = false
    @State private var showingContentView = false
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            if content != nil {
                // Show existing content
                showingContentView = true
            } else {
                // Show action sheet to add new content
                showingActionSheet = true
            }
        }) {
            VStack(spacing: 12) {
                topContent
                
                Text(item.title)
                    .font(.system(size: 14, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(.ultraThinMaterial)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
        .sheet(isPresented: $showingActionSheet) {
            ProgressActionSheet(
                progressItem: item,
                isPresented: $showingActionSheet,
                onPhoto: { image in
                    onPhoto(image)
                },
                onNote: { text in
                    onNote(text)
                }
            )
        }
        .sheet(isPresented: $showingContentView) {
            ContentViewSheet(
                progressItem: item,
                content: content!,
                isPresented: $showingContentView,
                onPhoto: { image in
                    onPhoto(image)
                },
                onNote: { text in
                    onNote(text)
                }
            )
        }
    }
    
    @ViewBuilder
    private var topContent: some View {
        switch content {
        case .photo(let image):
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)
                    .frame(height: 120)
                    .overlay(
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(height: 120)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    )
            }
        case .note(let text):
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(item.color.opacity(0.1))
                    .frame(height: 120)
                
                Text(text)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .padding(.horizontal, 8)
            }
        case .none:
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(item.color.opacity(0.1))
                    .frame(height: 120)
                
                Image(systemName: item.iconName)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(item.color)
            }
        }
    }
}

// New view to display existing content
struct ContentViewSheet: View {
    let progressItem: ProgressItem
    let content: ProgressCardContent
    @Binding var isPresented: Bool
    let onPhoto: (UIImage) -> Void
    let onNote: (String) -> Void
    @State private var showingActionSheet = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Progress Item Info
                VStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(progressItem.color.opacity(0.1))
                            .frame(height: 80)
                        
                        Image(systemName: progressItem.iconName)
                            .font(.system(size: 32, weight: .medium))
                            .foregroundColor(progressItem.color)
                    }
                    
                    Text(progressItem.title)
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                }
                .padding(.top, 20)
                
                // Content Display
                VStack(spacing: 16) {
                    switch content {
                    case .photo(let image):
                        VStack(spacing: 12) {
                            Text("Current Photo")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(.primary)
                            
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 300)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        
                    case .note(let text):
                        VStack(spacing: 12) {
                            Text("Current Note")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                                .foregroundColor(.primary)
                            
                            Text(text)
                                .font(.system(size: 16, weight: .medium, design: .default))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.ultraThinMaterial)
                                )
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: {
                        showingActionSheet = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "pencil")
                                .font(.system(size: 16, weight: .medium))
                            Text("Change Content")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(progressItem.color)
                        )
                    }
                    
                    Button(action: {
                        // Clear the content
                        switch content {
                        case .photo:
                            onPhoto(UIImage()) // Empty image to clear
                        case .note:
                            onNote("") // Empty string to clear
                        }
                        isPresented = false
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "trash")
                                .font(.system(size: 16, weight: .medium))
                            Text("Remove Content")
                                .font(.system(size: 16, weight: .semibold, design: .default))
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.red.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(.red.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationTitle("View Content")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        isPresented = false
                    }
                    .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showingActionSheet) {
            ProgressActionSheet(
                progressItem: progressItem,
                isPresented: $showingActionSheet,
                onPhoto: { image in
                    onPhoto(image)
                    isPresented = false
                },
                onNote: { text in
                    onNote(text)
                    isPresented = false
                }
            )
        }
    }
}

#Preview {
    ProgressCard(
        item: ProgressItem(
            title: "Workout",
            iconName: "dumbbell.fill",
            color: .orange
        ),
        content: .none,
        onPhoto: { _ in },
        onNote: { _ in }
    )
    .padding()
} 