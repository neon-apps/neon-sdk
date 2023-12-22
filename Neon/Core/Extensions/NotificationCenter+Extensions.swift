//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation

extension NotificationCenter {

    public class func observe(name: NSNotification.Name, handler: @escaping (Notification) -> Void) -> NSObject{
        return self.default.addObserver(forName: name, object: nil, queue: .main, using: handler) as! NSObject
    }
    
    
}

