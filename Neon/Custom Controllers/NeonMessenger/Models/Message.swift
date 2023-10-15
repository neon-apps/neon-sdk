//
//  Message.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 12.09.2023.
//

import Foundation


public class Message{
    internal init(content: String = String(), sender: NeonMessengerUser = NeonMessengerUser(), date : Date = Date(), isRead : Bool = Bool() , id : String = String()) {
        self.content = content
        self.sender = sender
        self.date = date
        self.isRead = isRead
        self.id = id
    }
    
    
    var content = String()
    var sender = NeonMessengerUser()
    var date = Date()
    var isRead = false
    var id = String()

}


extension [Message]{
    mutating func sortByDate(){
        self.sort(by: {$0.date < $1.date})
    }
}
