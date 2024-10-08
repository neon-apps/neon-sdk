//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 9.03.2023.
//

import Foundation

extension Date {
    public func returnString(format : String = "MM/dd/yyyy", timeZone: String? = nil) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        if let timeZone{
            dateFormatter.timeZone = TimeZone(identifier: timeZone)
        }
        return dateFormatter.string(from: self)
    }
}
