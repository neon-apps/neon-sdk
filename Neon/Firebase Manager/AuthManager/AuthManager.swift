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
    
    
    public static func createUser(withEmail : String, password : String, completion : @escaping  (_ authResult : AuthDataResult?, _ error : Error?) -> ()){
        Auth.auth().createUser(withEmail: withEmail, password: password) { authResult, error in
          completion(authResult,error)
        }
    }
    
    public static func signIn(withEmail : String, password : String, completion : @escaping (_ authResult : AuthDataResult?, _ error : Error?) -> ()){
        Auth.auth().signIn(withEmail: withEmail, password: password) { authResult, error in
          completion(authResult,error)
        }
    }
    
    public static func signOut(completion : (_ success : Bool,_ error : Error?) -> ()){
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            completion(true, nil)
        } catch let signOutError as NSError {
            completion(false, signOutError)
        }
    }
    
    
}
#endif
