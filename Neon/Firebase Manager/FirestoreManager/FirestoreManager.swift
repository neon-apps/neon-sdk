//
//  FirestoreManager.swift
//  NeonSDK
//
//  Created by Tuna Öztürk on 8.04.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift



public class FirestoreManager{
    
    
    // Post Operations
    
    
    /// This function will delete any previous data on the document and override fields to document.
    public static func setDocument(path : [FirestoreReferance], fields : [String : Any]){
        let referance = FirestoreReferanceManager.shared.prepareFirebaseDocumentRef(path)
        referance.setData(fields)
    }
    
    public static func setDocument(path : [FirestoreReferance], object : Encodable){
        
        
        let referance = FirestoreReferanceManager.shared.prepareFirebaseDocumentRef(path)
        
        do {
            try referance.setData(from: object)
        } catch let error {
            print("Error writing city to Firestore: \(error)")
        }
    }
    
    /// If document not exist, this function won't work. It will change if it find fields in the document. It will add new fields, if exist but it won't any remove fields.
    public static func updateDocument(path : [FirestoreReferance], fields : [String : Any]){
        let referance = FirestoreReferanceManager.shared.prepareFirebaseDocumentRef(path)
        referance.updateData(fields)
    }
    
    /// This function won't delete sub-collections. You should delete all of the sub-documents one-by-one to delete sub-collections.
    public static func deleteDocument(path : [FirestoreReferance]){
        let referance = FirestoreReferanceManager.shared.prepareFirebaseDocumentRef(path)
        referance.delete()
    }
    
    
    
    // Get Operations
    
    
    public static func getDocument(path : [FirestoreReferance], completion : @escaping (_ documentID : String, _ documentData : [String : Any]) -> ()){
        let referance = FirestoreReferanceManager.shared.prepareFirebaseDocumentRef(path)
        referance.getDocument { (document, error) in
            if let document = document, document.exists {
                let documentID = document.documentID
                let documentData = document.data()
                guard let documentData else {
                    print("Document couldn't fetched because it does not have any fields")
                    return
                }
                completion(documentID, documentData)
            } else {
                print("Document does not exist")
            }
        }
        
    }
    
    
    public static func getDocument<T: Decodable>(path : [FirestoreReferance], objectType : T.Type, completion : @escaping (_ object : Encodable) -> ()){
        let referance = FirestoreReferanceManager.shared.prepareFirebaseDocumentRef(path)
        referance.getDocument(as: objectType) { result in
            
            switch result {
            case .success(let object):
                if let encodableObject = object as? Encodable{
                    completion(encodableObject)
                }else{
                    print("Fetched object is not encodable")
                }
            case .failure(let error):
                print("Error decoding object: \(error)")
            }
        }
    }
    
    
   

}
