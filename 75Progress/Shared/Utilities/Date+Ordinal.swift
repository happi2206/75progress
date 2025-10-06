//
//  Date+Ordinal.swift
//  75Progress
//
//

import Foundation

extension Int {
    var ordinalSuffix: String {
        let ones = self % 10
        let tens = (self / 10) % 10
        if tens == 1 { return "th" }
        switch ones {
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default: return "th"
        }
    }

    var ordinalString: String {
        "\(self)\(ordinalSuffix)"
    }
}

extension Date {
    /// e.g. "Saturday 4th of October"
    var longWithOrdinal: String {
        let calendar = Calendar.current
        let weekday = DateFormatter.weekdayFormatter.string(from: self)
        let month = DateFormatter.monthFormatter.string(from: self)
        let day = calendar.component(.day, from: self).ordinalString
        return "\(weekday) \(day) of \(month)"
    }
}

extension DateFormatter {
    static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter
    }()

    static let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMM")
        return formatter
    }()
}
