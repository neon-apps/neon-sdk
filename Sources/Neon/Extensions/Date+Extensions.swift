//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 9.03.2023.
//

import Foundation

extension Date {
    public func returnString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter.string(from: self)
    }
}
