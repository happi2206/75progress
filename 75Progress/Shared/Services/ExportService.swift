//
//  ExportService.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation
import UIKit
import PDFKit

class ExportService {
    
    func export(entries: [DayEntry], format: ExportFormat) async throws -> URL {
        switch format {
        case .collage:
            return try await createCollage(from: entries)
        case .pdf:
            return try await createPDF(from: entries)
        }
    }
    
    // MARK: - Collage Export
    
    private func createCollage(from entries: [DayEntry]) async throws -> URL {
        let collageImage = try await generateCollageImage(from: entries)
        
        guard let imageData = collageImage.jpegData(compressionQuality: 0.8) else {
            throw ExportError.imageGenerationFailed
        }
        
        let fileName = "75Progress_Collage_\(Date().timeIntervalSince1970).jpg"
        let fileURL = try getDocumentsDirectory().appendingPathComponent(fileName)
        
        try imageData.write(to: fileURL)
        return fileURL
    }
    
    private func generateCollageImage(from entries: [DayEntry]) async throws -> UIImage {
        let size = CGSize(width: 1200, height: 1600)
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { context in
            // Background
            UIColor.systemBackground.setFill()
            context.fill(CGRect(origin: .zero, size: size))
            
            // Header
            let headerRect = CGRect(x: 40, y: 40, width: size.width - 80, height: 120)
            drawHeader(in: headerRect, entries: entries)
            
            // Grid of photos
            let gridRect = CGRect(x: 40, y: 180, width: size.width - 80, height: size.height - 220)
            drawPhotoGrid(in: gridRect, entries: entries)
        }
    }
    
    private func drawHeader(in rect: CGRect, entries: [DayEntry]) {
        let title = "75 Progress Challenge"
        let subtitle = "\(entries.count) days of progress"
        
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.boldSystemFont(ofSize: 32),
            .foregroundColor: UIColor.label
        ]
        
        let subtitleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.secondaryLabel
        ]
        
        let titleSize = title.size(withAttributes: titleAttributes)
        let subtitleSize = subtitle.size(withAttributes: subtitleAttributes)
        
        let titleRect = CGRect(
            x: rect.midX - titleSize.width / 2,
            y: rect.minY,
            width: titleSize.width,
            height: titleSize.height
        )
        
        let subtitleRect = CGRect(
            x: rect.midX - subtitleSize.width / 2,
            y: rect.minY + titleSize.height + 8,
            width: subtitleSize.width,
            height: subtitleSize.height
        )
        
        title.draw(in: titleRect, withAttributes: titleAttributes)
        subtitle.draw(in: subtitleRect, withAttributes: subtitleAttributes)
    }
    
    private func drawPhotoGrid(in rect: CGRect, entries: [DayEntry]) {
        let columns = 3
        let rows = 4
        let cellWidth = rect.width / CGFloat(columns)
        let cellHeight = rect.height / CGFloat(rows)
        
        var entryIndex = 0
        
        for row in 0..<rows {
            for col in 0..<columns {
                if entryIndex < entries.count {
                    let cellRect = CGRect(
                        x: rect.minX + CGFloat(col) * cellWidth,
                        y: rect.minY + CGFloat(row) * cellHeight,
                        width: cellWidth - 8,
                        height: cellHeight - 8
                    )
                    
                    drawPhotoCell(in: cellRect, entry: entries[entryIndex])
                    entryIndex += 1
                }
            }
        }
    }
    
    private func drawPhotoCell(in rect: CGRect, entry: DayEntry) {
        // Background
        UIColor.systemGray6.setFill()
        UIBezierPath(roundedRect: rect, cornerRadius: 12).fill()
        
        // Photo placeholder
        let photoRect = CGRect(
            x: rect.minX + 8,
            y: rect.minY + 8,
            width: rect.width - 16,
            height: rect.height - 40
        )
        
        UIColor.systemBlue.withAlphaComponent(0.1).setFill()
        UIBezierPath(roundedRect: photoRect, cornerRadius: 8).fill()
        
        // Date
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let dateString = formatter.string(from: entry.date)
        
        let dateAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.label
        ]
        
        let dateSize = dateString.size(withAttributes: dateAttributes)
        let dateRect = CGRect(
            x: rect.midX - dateSize.width / 2,
            y: rect.maxY - dateSize.height - 8,
            width: dateSize.width,
            height: dateSize.height
        )
        
        dateString.draw(in: dateRect, withAttributes: dateAttributes)
    }
    
    // MARK: - PDF Export
    
    private func createPDF(from entries: [DayEntry]) async throws -> URL {
        let pdfData = try generatePDFData(from: entries)
        
        let fileName = "75Progress_Report_\(Date().timeIntervalSince1970).pdf"
        let fileURL = try getDocumentsDirectory().appendingPathComponent(fileName)
        
        try pdfData.write(to: fileURL)
        return fileURL
    }
    
    private func generatePDFData(from entries: [DayEntry]) throws -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: "75Progress App",
            kCGPDFContextAuthor: "User",
            kCGPDFContextTitle: "75 Progress Challenge Report"
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let pageRect = CGRect(x: 0, y: 0, width: 612, height: 792) // US Letter size
        let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
        
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Title
            let title = "75 Progress Challenge Report"
            let titleAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.boldSystemFont(ofSize: 24),
                .foregroundColor: UIColor.black
            ]
            
            let titleSize = title.size(withAttributes: titleAttributes)
            let titleRect = CGRect(
                x: (pageRect.width - titleSize.width) / 2,
                y: 40,
                width: titleSize.width,
                height: titleSize.height
            )
            
            title.draw(in: titleRect, withAttributes: titleAttributes)
            
            // Summary
            let summary = "Total Days: \(entries.count)\nCompletion Rate: \(calculateCompletionRate(entries))%"
            let summaryAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.black
            ]
            
            let summaryRect = CGRect(x: 40, y: 80, width: pageRect.width - 80, height: 60)
            summary.draw(in: summaryRect, withAttributes: summaryAttributes)
            
            // Entries
            var yPosition: CGFloat = 160
            for entry in entries.prefix(20) { // Limit to first 20 entries
                let entryText = formatEntryForPDF(entry)
                let entryAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 12),
                    .foregroundColor: UIColor.black
                ]
                
                let entryRect = CGRect(x: 40, y: yPosition, width: pageRect.width - 80, height: 30)
                entryText.draw(in: entryRect, withAttributes: entryAttributes)
                
                yPosition += 35
                
                // Start new page if needed
                if yPosition > pageRect.height - 100 {
                    context.beginPage()
                    yPosition = 40
                }
            }
        }
        
        return data
    }
    
    private func calculateCompletionRate(_ entries: [DayEntry]) -> Int {
        guard !entries.isEmpty else { return 0 }
        let completedCount = entries.filter { $0.isComplete }.count
        return Int((Double(completedCount) / Double(entries.count)) * 100)
    }
    
    private func formatEntryForPDF(_ entry: DayEntry) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        let dateString = formatter.string(from: entry.date)
        
        let photoCount = entry.photos.count
        let status = entry.isComplete ? "✓ Complete" : "○ In Progress"
        
        return "\(dateString) - \(photoCount) photos - \(status)"
    }
    
    // MARK: - Utilities
    
    private func getDocumentsDirectory() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
    }
}

enum ExportError: Error {
    case imageGenerationFailed
    case pdfGenerationFailed
    case fileWriteFailed
} 