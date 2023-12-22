//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 27.09.2023.
//

import Foundation


public class NeonNotificationCenter{
    
    private static var activeObservers = [(NSObject, String)]()
    public static func post(id : String, object : Any? = nil){
        
        if let object{
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: id), userInfo: ["neon-object" : object]))
        }else{
            NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: id), userInfo: nil))
        }
        
    }
    
    public static func observe(id : String, completion: @escaping (_ object : Any?) -> ()){
        var notificationObject = NotificationCenter.observe(name: Notification.Name(rawValue: id)) { notification in
            if let userInfo = notification.userInfo as? [String : Any], let object = userInfo["neon-object"]{
                    completion(object)
            }else{
                completion(nil)
            }
        }
        activeObservers.append((notificationObject,id))
    }
    
    public static func observe(id : String, completion: @escaping () -> ()){
        var notificationObject =  NotificationCenter.observe(name: Notification.Name(rawValue: id)) { notification in
            completion()
        }
        activeObservers.append((notificationObject,id))
    }
    
    public static func removeAllObservers(){
        for observer in activeObservers {
            NotificationCenter.removeObserver(observer.0, forKeyPath: observer.1)
        }
    }
    
    
}

