//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 28.03.2023.
//

import Foundation
import UIKit
import FirebaseStorage

public class StorageManager{
    
    public static func uploadImage(image : UIImage, storageRef : String? = nil, completion : @escaping (_ downloadURL : String?) -> ()){
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let data = image.jpegData(compressionQuality: 0.5)
        let imageID = UUID().uuidString
        let imageRef = storageRef.child("\(storageRef ?? imageID).png")
        
        let newMetadata = StorageMetadata()
        newMetadata.contentType = "image/png"
        
        _ = imageRef.putData(data!, metadata: newMetadata) { (metadata, error) in
            imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    completion(nil)
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
        
    }
    
}
