//
//  ProgressEntry.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation
import UIKit

// Define a custom color type that doesn't depend on SwiftUI
enum ColorType: String, Codable, CaseIterable {
    case blue = "blue"
    case orange = "orange"
    case green = "green"
    case red = "red"
    case purple = "purple"
    case pink = "pink"
    case yellow = "yellow"
    case gray = "gray"
    
    var displayName: String {
        return rawValue.capitalized
    }
}

struct ProgressEntry: Identifiable, Codable {
    let id: UUID
    let progressItemTitle: String
    let progressItemIcon: String
    let progressItemColor: ColorType
    let date: Date
    let type: EntryType
    let content: String  
    let imageData: Data?
    
    enum EntryType: String, Codable, CaseIterable {
        case photo = "Photo"
        case note = "Note"
        case importedPhoto = "Imported Photo"
        
        var icon: String {
            switch self {
            case .photo:
                return "camera.fill"
            case .note:
                return "note.text"
            case .importedPhoto:
                return "photo.fill"
            }
        }
    }
    
    init(progressItem: ProgressItem, type: EntryType, content: String, imageData: Data? = nil) {
        self.id = UUID()
        self.progressItemTitle = progressItem.title
        self.progressItemIcon = progressItem.iconName
        self.progressItemColor = progressItem.colorType
        self.date = Date()
        self.type = type
        self.content = content
        self.imageData = imageData
    }
}

// Extension to convert ProgressItem color to our custom ColorType
extension ProgressItem {
    var colorType: ColorType {
        // Convert the SwiftUI Color to our custom ColorType
        // This will be called from the view layer where SwiftUI is available
        if self.color == .blue { return .blue }
        if self.color == .orange { return .orange }
        if self.color == .green { return .green }
        if self.color == .red { return .red }
        if self.color == .purple { return .purple }
        if self.color == .pink { return .pink }
        if self.color == .yellow { return .yellow }
        if self.color == .gray { return .gray }
        return .blue // default
    }
}
