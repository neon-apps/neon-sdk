//
//  File.swift
//
//
//  Created by Tuna Öztürk on 9.03.2023.
//

import Foundation

extension Date {
    public func returnString(format: String = "MM/dd/yyyy", timeZone: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Set time zone if provided, otherwise default to UTC
        if let timeZone = timeZone {
            dateFormatter.timeZone = TimeZone(identifier: timeZone)
        } else {
            dateFormatter.timeZone = TimeZone(identifier: "UTC") // Default to UTC if no time zone is provided
        }
        
        return dateFormatter.string(from: self)
    }
}
