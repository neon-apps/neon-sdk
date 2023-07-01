//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 8.04.2023.
//
#if !os(xrOS)
import Foundation
import FirebaseAuth

public class AuthManager{
    
    public static func signInAnonymously(){
        Auth.auth().signInAnonymously { authResult, error in
          // ...
        }
    }
    public static var currentUserID : String?{
        return Auth.auth().currentUser?.uid
    }
    
}
#endif
