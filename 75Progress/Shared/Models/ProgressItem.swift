//
//  ProgressItem.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import SwiftUI

struct ProgressItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let color: Color
    let storageKey: String

    init(title: String, iconName: String, color: Color, storageKey: String? = nil) {
        self.title = title
        self.iconName = iconName
        self.color = color
        if let storageKey {
            self.storageKey = storageKey
        } else {
            self.storageKey = title
                .lowercased()
                .replacingOccurrences(of: " ", with: "_")
        }
    }
}
