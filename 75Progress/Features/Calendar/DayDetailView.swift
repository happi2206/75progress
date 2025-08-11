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
                    
                    // Photos Grid
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Photos")
                                .font(.system(size: 18, weight: .semibold, design: .default))
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Button(action: {
                                addPhoto()
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                        }
                        
                        if let entry = entry, !entry.photos.isEmpty {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(entry.photos) { photo in
                                    PhotoCard(
                                        photo: photo,
                                        note: entry.notes[photo.id] ?? "",
                                        onDelete: {
                                            deletePhoto(photo)
                                        }
                                    )
                                }
                            }
                        } else {
                            VStack(spacing: 12) {
                                Image(systemName: "camera")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(.secondary)
                                
                                Text("No photos yet")
                                    .font(.system(size: 16, weight: .medium, design: .default))
                                    .foregroundColor(.secondary)
                                
                                Button("Add Photo") {
                                    addPhoto()
                                }
                                .font(.system(size: 14, weight: .semibold, design: .default))
                                .foregroundColor(.blue)
                            }
                            .padding(.vertical, 40)
                        }
                    }
                    .padding(.horizontal, 20)
                    
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
    
    private func deletePhoto(_ photo: PhotoItem) {
        guard var currentEntry = entry else { return }
        currentEntry.photos.removeAll { $0.id == photo.id }
        currentEntry.notes.removeValue(forKey: photo.id)
        
        viewModel.saveEntry(currentEntry)
        entry = currentEntry
    }
}

struct PhotoCard: View {
    let photo: PhotoItem
    let note: String
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.blue.opacity(0.1))
                    .frame(height: 120)
                
                Image(systemName: "photo")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(.blue)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(photo.label)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                if !note.isEmpty {
                    Text(note)
                        .font(.system(size: 12, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
            }
            
            HStack {
                Spacer()
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    DayDetailView(date: Date(), viewModel: CalendarViewModel())
} 