//
//  NeonReferralDatabase.swift
//  PromotionCode
//
//  Created by cihangirincaz on 30.07.2024.
//

import UIKit
import NeonSDK
import Firebase
import FirebaseStorage
import FirebaseFirestore

@available(iOS 16.0, *)
final class NeonReferralDatabase {
    static let shared = NeonReferralDatabase()
    
    private init() {}
    private var db: Firestore {
        Firestore.firestore()
    }
    private var storage: Storage {
        Storage.storage()
    }

    func fetchUsers(completion: @escaping (Bool) -> Void) {
        db.collection("ReferralManagerUsers").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
                completion(false)
            } else {
                var users: [String] = []
                for document in querySnapshot!.documents {
                    users.append(document.documentID)
                }
                NeonReferralConstants.shared.AllUser = users
                completion(true)
            }
        }
    }

    func setDatabase(userID: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("ReferralManagerUsers").document(userID)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if document.get("Credit") != nil {
                    print("Credit field already exists")
                    completion("haveCreditField")
                } else {
                    userRef.setData([
                        "Credit": 0
                    ], merge: true) { error in
                        if let error = error {
                            print("Error writing document: \(error)")
                            completion("error")
                        } else {
                            print("Document successfully written!")
                            completion("createdCreditField")
                        }
                    }
                }
            } else {
                completion("documentNotFound")
            }
        }
    }

    private func checkPromoCode(for userID: String, promoCode: String, completion: @escaping (Bool) -> Void) {
        let userDocRef = db.collection("ReferralManagerUsers").document(userID)
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let usedPromoCodes = document.data()?["Used Promo Codes"] as? [String] {
                    completion(!usedPromoCodes.contains(promoCode))
                } else {
                    completion(true)
                }
            } else {
                completion(true)
            }
        }
    }

    func addCredit(for userID: String, amount: Int) {
        
        let userDocRef = db.collection("ReferralManagerUsers").document(userID)
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let currentCredit = document.data()?["Credit"] as? Int {
                    let newCredit = currentCredit + amount
                    userDocRef.updateData(["Credit": newCredit]) { error in
                        if let error = error {
                            print("Error updating credit: \(error)")
                        } else {
                            print("Credit updated successfully. New Credit: \(newCredit)")
                        }
                    }
                }
            }
        }
    }

    func scanAllUsers(promotionCode: String, completion: @escaping (String) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let newUserID = String(userID.prefix(6))

        for user in NeonReferralConstants.shared.newAllUsers {
            if user == promotionCode {
                if promotionCode == newUserID {
                    completion("yourCode")
                    return
                } else {
                    fetchOrCreatePromoCodes(for: promotionCode) { success in
                        if success {
                            completion("promoCodeAdded")
                        } else {
                            completion("noPromoCodeAdded")
                        }
                    }
                    return
                }
            }
        }
        completion("badCode")
    }

    func fetchUserCredit(completion: @escaping (Int?, Error?) -> Void) {
        guard let userID = AuthManager.currentUserID else { return }

        let db = Firestore.firestore()
        let userRef = db.collection("ReferralManagerUsers").document(userID)
        userRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
            } else if let document = document, document.exists {
                if let data = document.data(), let credit = data["Credit"] as? Int {
                    completion(credit, nil)
                } else {
                    completion(nil, nil)
                }
            } else {
                completion(nil, nil)
            }
        }
    }
    func decreaseCredit(userId: String , amount : Int) {
        let db = Firestore.firestore()
        let userRef = db.collection("ReferralManagerUsers").document(userId)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if var credit = document.data()?["Credit"] as? Int {
                    credit -= amount
                    userRef.updateData([
                        "Credit": credit
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    }
                } else {
                    print("Credit field does not exist")
                }
            } else {
                print("Document does not exist")
            }
        }
    }


    private func fetchOrCreatePromoCodes(for promotionCode: String, completion: @escaping (Bool) -> Void) {
        guard let userID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        let userDocRef = db.collection("ReferralManagerUsers").document(userID)
        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if var usedPromoCodes = document.get("Used Promo Codes") as? [String] {
                    if !usedPromoCodes.contains(promotionCode) {
                        usedPromoCodes.append(promotionCode)
                        self.updatePromoCodes(for: userID, with: usedPromoCodes) { success in
                            completion(success)
                        }
                    } else {
                        completion(false)
                    }
                } else {
                    self.updatePromoCodes(for: userID, with: [promotionCode]) { success in
                        completion(success)
                    }
                }
            } else {
                completion(false)
            }
        }
    }

    private func updatePromoCodes(for userID: String, with usedPromoCodes: [String], completion: @escaping (Bool) -> Void) {
        let userDocRef = db.collection("ReferralManagerUsers").document(userID)
        userDocRef.updateData(["Used Promo Codes": usedPromoCodes]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
}
