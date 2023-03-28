//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 11.03.2023.
//

import Foundation

extension String {
    public func returnDate(format : String = "MM/dd/yyyy") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return Date()
        }
    }
}
