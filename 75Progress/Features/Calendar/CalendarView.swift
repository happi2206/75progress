//
//  CalendarView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var showSharePicker = false
    @State private var showDayDetail = false
    
    private let weekdays = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Calendar")
                            .font(.system(size: 28, weight: .bold, design: .default))
                            .foregroundColor(.primary)
                        
                        Text("Track your progress over time")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showSharePicker = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.blue)
                            .padding(12)
                            .background(
                                Circle()
                                    .fill(.blue.opacity(0.1))
                            )
                    }
                }
                
                // Month Navigation
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.previousMonth()
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                            )
                    }
                    
                    Spacer()
                    
                    Text(monthYearString)
                        .font(.system(size: 20, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            viewModel.nextMonth()
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                            )
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 24)
            
            // Weekday Headers
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { weekday in
                    Text(weekday)
                        .font(.system(size: 14, weight: .semibold, design: .default))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
            
            // Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(viewModel.daysInMonth().enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        DayCell(
                            date: date,
                            entry: viewModel.entry(for: date),
                            completion: viewModel.completion(for: date),
                            isSelected: Calendar.current.isDate(date, inSameDayAs: viewModel.selectedDate ?? Date()),
                            onTap: {
                                viewModel.selectedDate = date
                                showDayDetail = true
                            }
                        )
                    } else {
                        Color.clear
                            .frame(height: 50)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // Current Streak
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Streak")
                        .font(.system(size: 14, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 8) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.orange)
                        
                        Text("\(viewModel.currentStreak()) days")
                            .font(.system(size: 18, weight: .bold, design: .default))
                            .foregroundColor(.primary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            
            Spacer()
        }
        .navigationBarHidden(true)
        .onAppear {
            // Load data when view appears to ensure Core Data is ready
            viewModel.loadMonth(viewModel.currentMonth)
        }
        .sheet(isPresented: $showDayDetail) {
            if let selectedDate = viewModel.selectedDate {
                DayDetailView(date: selectedDate, viewModel: viewModel)
            }
        }
        .sheet(isPresented: $showSharePicker) {
            SharePickerView(viewModel: viewModel)
        }
    }
    
    private var monthYearString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: viewModel.currentMonth)
    }
}

struct DayCell: View {
    let date: Date
    let entry: DayEntry?
    let completion: Double
    let isSelected: Bool
    let onTap: () -> Void
    
    private let calendar = Calendar.current
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                Text("\(calendar.component(.day, from: date))")
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(isToday ? .white : .primary)
                
                if let entry = entry {
                    HStack(spacing: 2) {
                        ForEach(0..<min(entry.photos.count, 3), id: \.self) { index in
                            Circle()
                                .fill(.blue)
                                .frame(width: 4, height: 4)
                        }
                    }
                    
                    if completion >= 0.8 {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var isToday: Bool {
        calendar.isDateInToday(date)
    }
    
    private var backgroundColor: Color {
        if isToday {
            return .blue
        } else if completion >= 0.8 {
            return .green.opacity(0.1)
        } else if completion > 0 {
            return .orange.opacity(0.1)
        } else {
            return .clear
        }
    }
}

#Preview {
    CalendarView()
} 