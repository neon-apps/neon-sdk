//
//  FirestoreManager.swift
//  NeonSDK
//
//  Created by Tuna Öztürk on 8.04.2023.
//

import Foundation
import FirebaseFirestore


public enum FirestoreReferance{
    case document(name : String)
    case collection(name : String)
}

class FirestoreReferanceManager{
    
    static let shared = FirestoreReferanceManager()
    
    func prepareFirebaseDocumentRef(_ path: [FirestoreReferance]) -> DocumentReference {
        guard path.count >= 2 else {
            fatalError("The path array must contain at least 2 elements (1 collection and 1 document)")
        }
        
        guard case .collection = path[0] else {
            fatalError("The first element of the path array must be a collection reference")
        }
        
        guard case .document = path[1] else {
            fatalError("The second element of the path array must be a document reference")
        }
        
        guard path.count % 2 == 0 else {
            fatalError("The path array must have an even number of elements")
        }
        
        var collectionRef: CollectionReference = Firestore.firestore().collection(getCollectionName(path[0]))
        var documentRef: DocumentReference = collectionRef.document(getDocumentName(path[1]))
        
        for i in stride(from: 2, to: path.count, by: 2) {
            guard case .collection = path[i] else {
                fatalError("Collection reference expected at position \(i) in the path array")
            }
            
            guard case .document = path[i+1] else {
                fatalError("Document reference expected at position \(i+1) in the path array")
            }
            
            let collectionName = getCollectionName(path[i])
            let documentName = getDocumentName(path[i+1])
            collectionRef = documentRef.collection(collectionName)
            documentRef = collectionRef.document(documentName)
        }
        
        return documentRef
    }

    func getCollectionName(_ reference: FirestoreReferance) -> String {
        switch reference {
        case .document(let name):
            return name
        case .collection(let name):
            return name
        }
    }

    func getDocumentName(_ reference: FirestoreReferance) -> String {
        switch reference {
        case .document(let name):
            return name
        case .collection(let _):
            fatalError("Collection reference cannot be the last element of the path array")
        }
    }
}
