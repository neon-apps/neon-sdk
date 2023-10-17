//
//  NeonMessengerManager.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 11.09.2023.
//

import Foundation
import UIKit
import NeonSDK
import Firebase
import FirebaseFirestoreSwift

class NeonMessengerManager{
    
    static var arrConnections = [NeonMessengerUser]()
    static var currentUser = NeonMessengerUser()
    

    
    
    static func addMessage(connection : NeonMessengerUser, content: String, sender : NeonMessengerUser, chat : inout [Message]){
        let newMessage = Message(content: content, sender: sender, date: Date())
        chat.append(newMessage)
        
        // Save message to user's chats
        
        FirestoreManager.setDocument(path: [
            .collection(name: "Users"),
            .document(name: NeonMessengerManager.currentUser.id),
            .collection(name: "Chats"),
            .document(name: connection.id),
            .collection(name: "Messages"),
            .document(name: UUID().uuidString)
        ], fields: ["content" : content,
                    "senderID" : sender.id,
                    "read" : true,
                    "date" : Date()
                   ])
        
        // Save message to connection's chats
        
        FirestoreManager.setDocument(path: [
            .collection(name: "Users"),
            .document(name: connection.id),
            .collection(name: "Chats"),
            .document(name: NeonMessengerManager.currentUser.id),
            .collection(name: "Messages"),
            .document(name: UUID().uuidString)
        ], fields: ["content" : content,
                    "senderID" : sender.id,
                    "read" : false,
                    "date" : Date()
                   ])
        
    }
    
    static func getMessageFromDocument(connection : NeonMessengerUser,documentID : String, documentData : [String : Any]) -> Message?{
        
        if let content = documentData["content"] as? String,
           let senderID = documentData["senderID"] as? String,
           let isRead = documentData["read"] as? Bool,
           let timestamp = documentData["date"] as? Timestamp{
            
            let sender = (senderID == connection.id) ? connection : NeonMessengerManager.currentUser
            let date = timestamp.dateValue()
            
            return  Message(content: content, sender: sender , date : date, isRead: isRead, id: documentID)
        }
        
        return nil
        
    }
    
    static func fetchChat(connection : NeonMessengerUser,  completion : @escaping (_ messages : [Message]) -> () ){
        
        var arrMessages = [Message]()
        
        FirestoreManager.getDocuments(path: [
            .collection(name: "Users"),
            .document(name: NeonMessengerManager.currentUser.id),
            .collection(name: "Chats"),
            .document(name: connection.id),
            .collection(name: "Messages")
        ]) { documentID, documentData in
            
            if let newMessage = NeonMessengerManager.getMessageFromDocument(connection: connection, documentID: documentID, documentData: documentData){
                arrMessages.append(newMessage)
                arrMessages.sortByDate()
            }
            
            
        } isLastFetched: {
            completion(arrMessages)
        } isCollectionEmpty: {
            completion(arrMessages)
            
        }
        
        
    }
    
    static func listenChat(connection : NeonMessengerUser, chatUpdated : @escaping (_ newMessage : Message) -> ()){
        
        FirestoreManager.listenDocuments(path: [
            .collection(name: "Users"),
            .document(name: NeonMessengerManager.currentUser.id),
            .collection(name: "Chats"),
            .document(name: connection.id),
            .collection(name: "Messages")
        ]) { documentID, documentData, source, changeType in
            if let newMessage = NeonMessengerManager.getMessageFromDocument(connection: connection, documentID: documentID, documentData: documentData){
                if newMessage.sender != NeonMessengerManager.currentUser && newMessage.date > Date().addingTimeInterval(-5){
                        newMessage.isRead = true
                        chatUpdated(newMessage)
                    }
                }
        }
    }
    static func fetchLastMessages(completion:  @escaping () -> ()){
        var fetchedConnectionCount = 0
        for connection in NeonMessengerManager.arrConnections{
            
            let referance = FirestoreManager.prepareReferance(path: [
                .collection(name: "Users"),
                .document(name: NeonMessengerManager.currentUser.id),
                .collection(name: "Chats"),
                .document(name: connection.id),
                .collection(name: "Messages")
            ])
                .order(by: "date", descending: true)
                .limit(to: 1)
            
            FirestoreManager.getDocuments(referance: referance , completion: { documentID, documentData in
                
                if let content = documentData["content"] as? String,
                   let isRead = documentData["read"] as? Bool,
                   let timestamp = documentData["date"] as? Timestamp{
                    let date = timestamp.dateValue()
                    let message = Message(content: content, date : date, isRead: isRead, id: documentID)
                    connection.lastMessage = message
                }
                
                fetchedConnectionCount += 1
                if fetchedConnectionCount == NeonMessengerManager.arrConnections.count{
                    completion()
                }
            }, isCollectionEmpty : {
                fetchedConnectionCount += 1
                if fetchedConnectionCount == NeonMessengerManager.arrConnections.count{
                    completion()
                }
            })
            
        }
    }
    
    
    static func markChatAsRead(with user : NeonMessengerUser){
        guard let lastMessage = user.lastMessage else {return}
        FirestoreManager.updateDocument(path: [
            .collection(name: "Users"),
            .document(name: NeonMessengerManager.currentUser.id),
            .collection(name: "Chats"),
            .document(name: user.id),
            .collection(name: "Messages"),
            .document(name: lastMessage.id)
        ], fields: ["read" : true
                   ])
    }
    
    static func deleteChat(with user : NeonMessengerUser){
        
        fetchChat(connection: user) { messages in
            for message in messages {
                FirestoreManager.deleteDocument(path: [
                    .collection(name: "Users"),
                    .document(name: NeonMessengerManager.currentUser.id),
                    .collection(name: "Chats"),
                    .document(name: user.id),
                    .collection(name: "Messages"),
                    .document(name: message.id)
                ])
            }
        }
    }
}
