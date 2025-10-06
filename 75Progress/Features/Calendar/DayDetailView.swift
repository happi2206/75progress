//
//  DayDetailView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct DayDetailView: View {
    let date: Date
    let viewModel: CalendarViewModel
    
    @State private var entry: DayEntry?
    @State private var summary: String = ""
    @Environment(\.dismiss) private var dismiss
    
    private let calendar = Calendar.current
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text(dayString)
                            .font(.system(size: 24, weight: .bold, design: .default))
                            .foregroundColor(.primary)
                        
                        Text(dateString)
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Completion Status
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Completion")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.secondary)
                            
                            Text("\(Int(viewModel.completion(for: date) * 100))%")
                                .font(.system(size: 20, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                        }
                        
                        Spacer()
                        
                        CircularProgressView(progress: viewModel.completion(for: date))
                            .frame(width: 60, height: 60)
                    }
                    .padding(.horizontal, 20)
                    
                    // Entries preview
                    if let entry = entry {
                        EntriesGrid(entry: entry)
                            .padding(.horizontal, 20)
                    }
                    
                    // Summary
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Day Summary")
                            .font(.system(size: 18, weight: .semibold, design: .default))
                            .foregroundColor(.primary)
                        
                        TextField("Write your reflection for this day...", text: $summary, axis: .vertical)
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(.primary)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                            )
                            .lineLimit(4...8)
                            .onChange(of: summary) { oldValue, newValue in
                                saveEntry()
                            }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 100)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold, design: .default))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveEntry()
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .foregroundColor(.blue)
                }
            }
        }
        .onAppear {
            loadEntry()
        }
    }
    
    private var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }
    
    private var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    private func loadEntry() {
        entry = viewModel.entry(for: date)
        summary = entry?.summary ?? ""
    }
    
    private func saveEntry() {
        var currentEntry = entry ?? DayEntry(date: date)
        currentEntry.summary = summary.isEmpty ? nil : summary
        currentEntry.isComplete = viewModel.completion(for: date) >= 0.8
        
        viewModel.saveEntry(currentEntry)
        entry = currentEntry
    }
    
    private func addPhoto() {
        // Placeholder for photo picker
        print("Add photo tapped")
    }
    
}

struct EntriesGrid: View {
    let entry: DayEntry

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Entries")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.primary)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(entry.photos) { photo in
                    VStack(alignment: .leading, spacing: 8) {
                        AsyncImage(url: photo.url) { image in
                            image.resizable()
                                .scaledToFill()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.blue.opacity(0.1))
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.system(size: 26, weight: .medium))
                                        .foregroundColor(.blue)
                                )
                        }
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 14))

                        Text(photo.label)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)

                        if let note = entry.notes[photo.id], !note.isEmpty {
                            Text(note)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                                .lineLimit(2)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                    )
                }

                if let summary = entry.summary, !summary.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Reflection")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primary)

                        Text(summary)
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 3)
                    )
                }
            }
        }
    }
}

#Preview {
    DayDetailView(date: Date(), viewModel: CalendarViewModel())
} 
