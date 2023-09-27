//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 27.09.2023.
//

import Foundation


public class NeonNotificationCenter{
    
    public static func post(id : String, object : Any? = nil){
        
        if let object{
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: id), userInfo: ["neon-object" : object]))
        }else{
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: id), userInfo: nil))
        }
        
    }
    
    public static func observe(id : String, completion: @escaping (_ object : Any?) -> ()){
        NotificationCenter.observe(name: Notification.Name(rawValue: id)) { notification in
            if let userInfo = notification.userInfo as? [String : Any], let object = userInfo["neon-object"]{
                    completion(object)
            }else{
                completion(nil)
            }
        }
    }
    
    public static func observe(id : String, completion: @escaping () -> ()){
        NotificationCenter.observe(name: Notification.Name(rawValue: id)) { notification in
            completion()
        }
    }
    
    
}

