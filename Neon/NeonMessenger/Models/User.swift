//
//  User.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 11.09.2023.
//

import Foundation
import UIKit

public class NeonMessengerUser: Equatable{
    internal init(id : String = String(), firstName: String = String(), lastName: String = String(), photoURL: String = String()) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.photoURL = photoURL
       
    }
    
    
  
    
    var photoURL = String()
    var firstName = String()
    var lastName = String()
    var id = String()
    var lastMessage : Message?
    
    var fullName : String {
        get{
            return firstName + " " + lastName
        }
    }
    
    public static func == (lhs: NeonMessengerUser, rhs: NeonMessengerUser) -> Bool {
        return lhs.id == rhs.id
    }
    
}




