//
//  InspirationView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct InspirationView: View {
    @StateObject private var viewModel = InspirationViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Inspiration")
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                    
                    Text("Stay motivated with daily inspiration")
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                // Daily Quote
                DailyQuoteCard(quote: viewModel.dailyQuote)
                
                // Book Recommendations
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recommended Books")
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.recommendedBooks) { book in
                                BookCard(book: book)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .padding(.horizontal, 20)
                
                // Workout Suggestions
                VStack(alignment: .leading, spacing: 16) {
                    Text("Workout Ideas")
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(viewModel.workoutSuggestions) { workout in
                            WorkoutCard(workout: workout)
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                Spacer(minLength: 100)
            }
        }
        .navigationBarHidden(true)
    }
}

struct DailyQuoteCard: View {
    let quote: Quote
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(quote.text)")
                .font(.system(size: 18, weight: .medium, design: .default))
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
            
            HStack {
                Text("- \(quote.author)")
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Image(systemName: "quote.bubble.fill")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.blue)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 20)
    }
}

struct BookCard: View {
    let book: Book
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue.opacity(0.1))
                    .frame(width: 120, height: 160)
                
                Image(systemName: "book.fill")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(.blue)
            }
            
            Text(book.title)
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Text(book.author)
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(.secondary)
                .lineLimit(1)
        }
        .frame(width: 120)
    }
}

struct WorkoutCard: View {
    let workout: WorkoutSuggestion
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(workout.color.opacity(0.1))
                    .frame(height: 80)
                
                Image(systemName: workout.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(workout.color)
            }
            
            Text(workout.title)
                .font(.system(size: 14, weight: .semibold, design: .default))
                .foregroundColor(.primary)
                .lineLimit(2)
            
            Text(workout.duration)
                .font(.system(size: 12, weight: .medium, design: .default))
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    InspirationView()
} 
