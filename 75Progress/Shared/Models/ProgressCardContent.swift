//
//  ProgressCardContent.swift
//  75Progress
//
//  Created by Happiness Adeboye on 3/8/2025.
//

import Foundation
import UIKit

enum ProgressCardContent: Equatable {
    case photo(UIImage)
    case note(String)
    
    static func == (lhs: ProgressCardContent, rhs: ProgressCardContent) -> Bool {
        switch (lhs, rhs) {
        case (.photo(let lhsImage), .photo(let rhsImage)):
            return lhsImage.pngData() == rhsImage.pngData()
        case (.note(let lhsText), .note(let rhsText)):
            return lhsText == rhsText
        default:
            return false
        }
    }
}
