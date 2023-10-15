//
//  MessageDateFormatter.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 14.09.2023.
//

import Foundation

extension Date {
    
    func returnMessageDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        let calendar = Calendar.current
        
        // Check if the date is today
        if calendar.isDateInToday(self) {
            dateFormatter.dateFormat = "HH:mm"
            return dateFormatter.string(from: self)
        }
        
        // Check if the date is within the last week
        if calendar.isDate(self, equalTo: Date(), toGranularity: .weekOfYear) {
            dateFormatter.dateFormat = "EEEE"
            return dateFormatter.string(from: self)
        }
        
        // For dates older than a week
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: self)
    }
}
