//
//  String+Extensions.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation

extension String?{
    
    @available(iOS 13.0, *)
    func changeUsername() -> String{
        
        guard let firstName = NeonLongOnboardingConstants.firstName else{
            fatalError("You should add the name page at the begining of the onboarding.")
        }
        if let string = self{
            return string.replacingOccurrences(of: "first_name", with: firstName)
        }else{
            return ""
        }
       
    }
}

extension String{
    
    @available(iOS 13.0, *)
    func changeUsername() -> String{
        
        guard let firstName = NeonLongOnboardingConstants.firstName else{
            fatalError("You should add the name page at the begining of the onboarding.")
        }
        
        return self.replacingOccurrences(of: "first_name", with: firstName)
       
    }
}

