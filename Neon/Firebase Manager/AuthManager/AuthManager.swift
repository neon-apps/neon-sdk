//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 8.04.2023.
//

import Foundation
import FirebaseAuth

class AuthManager{
    
    func signInAnonymously(){
        Auth.auth().signInAnonymously { authResult, error in
          // ...
        }
    }
    
}
