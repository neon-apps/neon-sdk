//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 22.10.2023.
//

import Foundation
import UIKit

public class NeonValidationManager {
    
    // MARK: Email Validation
    
    public static func isValid(email: String) -> Bool {
        let emailRegex = #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // MARK: URL Validation
    
    public static func isValid(url: String) -> Bool {
        if let url = URL(string: url) {
            return UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}
