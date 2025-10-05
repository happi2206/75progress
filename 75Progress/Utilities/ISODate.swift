//
//  ISODate.swift
//  75Progress
//
//  Created by Happiness Adeboye on 4/10/2025.
//

import Foundation


enum ISODate {
    private static let df: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .iso8601)
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current      
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    static func string(from date: Date) -> String { df.string(from: date) }
    static func date(from string: String) -> Date? { df.date(from: string) }
}


extension Date {
    var yyyyMMdd: String { ISODate.string(from: self) }
}
