//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 8.04.2023.
//

import Foundation
import FirebaseAuth

public class AuthManager{
    
    public func signInAnonymously(){
        Auth.auth().signInAnonymously { authResult, error in
          // ...
        }
    }
    public var currentUserID : String{
        return Auth.auth().currentUser?.uid ?? "USER-ID-NİL"
    }
    
}
