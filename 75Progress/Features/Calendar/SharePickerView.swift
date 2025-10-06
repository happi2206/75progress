//
//  SharePickerView.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct SharePickerView: View {
    let viewModel: CalendarViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var selectedRange: ShareRange = .today
    @State private var exportFormat: ExportFormat = .collage
    @State private var isExporting = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("Share Progress")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                    
                    Text("Choose what to share and how")
                        .font(.system(size: 16, weight: .medium, design: .default))
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Range Selection
                VStack(alignment: .leading, spacing: 16) {
                    Text("Time Range")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 12) {
                        ForEach(ShareRange.allCases, id: \.self) { range in
                            RangeOptionCard(
                                range: range,
                                isSelected: selectedRange == range,
                                entryCount: viewModel.entriesForRange(range).count
                            ) {
                                selectedRange = range
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Export Format
                VStack(alignment: .leading, spacing: 16) {
                    Text("Export Format")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 12) {
                        ForEach(ExportFormat.allCases, id: \.self) { format in
                            FormatOptionCard(
                                format: format,
                                isSelected: exportFormat == format
                            ) {
                                exportFormat = format
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                
                // Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preview")
                        .font(.system(size: 18, weight: .semibold, design: .default))
                        .foregroundColor(.primary)
                    
                    let entries = viewModel.entriesForRange(selectedRange)
                    let (start, end) = viewModel.dateRange(for: selectedRange)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        let count = entries.count
                        Text("\(count) day\(count == 1 ? "" : "s") with entries")
                            .font(.system(size: 16, weight: .medium, design: .default))
                            .foregroundColor(.primary)
                        
                        Text("\(formatDate(start)) - \(formatDate(end))")
                            .font(.system(size: 14, weight: .medium, design: .default))
                            .foregroundColor(.secondary)
                        
                        if !entries.isEmpty {
                            Text("Completion rate: \(Int(averageCompletion(entries) * 100))%")
                                .font(.system(size: 14, weight: .medium, design: .default))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                    )
                }
                .padding(.horizontal, 20)
                
                Spacer()
                
                // Export Button
                Button(action: {
                    exportProgress()
                }) {
                    HStack {
                        if isExporting {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 18, weight: .medium))
                        }
                        
                        Text(isExporting ? "Exporting..." : "Export & Share")
                            .font(.system(size: 16, weight: .semibold, design: .default))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(isExporting ? Color.gray : Color.blue)
                    )
                }
                .disabled(isExporting)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold, design: .default))
                }
            }
        }
        .onAppear {
            viewModel.loadMonth(Date())
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
    
    private func averageCompletion(_ entries: [DayEntry]) -> Double {
        guard !entries.isEmpty else { return 0.0 }
        let total = entries.reduce(0.0) { sum, entry in
            sum + viewModel.completion(for: entry.date)
        }
        return total / Double(entries.count)
    }
    
    private func exportProgress() {
        isExporting = true
        
        let entries = viewModel.entriesForRange(selectedRange)
        let exportService = ExportService()
        
        Task {
            do {
                let url = try await exportService.export(entries: entries, format: exportFormat)
                
                await MainActor.run {
                    isExporting = false
                    shareFile(url)
                }
            } catch {
                await MainActor.run {
                    isExporting = false
                    print("Export failed: \(error)")
                }
            }
        }
    }
    
    private func shareFile(_ url: URL) {
        let activityVC = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
        
        dismiss()
    }
}

struct RangeOptionCard: View {
    let range: ShareRange
    let isSelected: Bool
    let entryCount: Int
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(range.rawValue)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Text("\(entryCount) entries")
                    .font(.system(size: 12, weight: .medium, design: .default))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct FormatOptionCard: View {
    let format: ExportFormat
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Image(systemName: format.icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? .white : .blue)
                
                Text(format.rawValue)
                    .font(.system(size: 14, weight: .semibold, design: .default))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? Color.blue : Color.secondary.opacity(0.3), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

enum ExportFormat: String, CaseIterable {
    case collage = "Collage"
    case pdf = "PDF"
    
    var icon: String {
        switch self {
        case .collage: return "rectangle.stack"
        case .pdf: return "doc.text"
        }
    }
}

#Preview {
    SharePickerView(viewModel: CalendarViewModel())
} 
