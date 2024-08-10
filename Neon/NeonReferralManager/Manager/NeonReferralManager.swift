//
//  NeonReferralManager.swift
//  PromotionCode
//
//  Created by cihangirincaz on 1.08.2024.
//

import UIKit
import NeonSDK
import FirebaseFirestore

@available(iOS 15.0, *)
class NeonReferralManager {
    //MARK: presentReferralController
    
    public static var remainingCredit : Int{
        get {
            return NeonReferralConstants.remainingCredit
        }
    }
    public static func presentReferralController(from viewController: UIViewController) {
        let referralVC = CodeViewVC()
        viewController.present(destinationVC: referralVC, slideDirection: .right)
    }
    //MARK: presentReddemController
    public static func presentReddemController(from viewController: UIViewController) {
        let reddemVC = CodeUseVC()
        custom(presentingVC: viewController, destinationVC: reddemVC, height: 224, cornerRadius: 24)
    }

    //MARK: Configure
    private static func setDatabase() {
        guard let userID = AuthManager.currentUserID else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("Users").document(userID)

        userRef.getDocument { document, error in
            if let document = document, document.exists {
                if document.get("Credit") != nil {
                    self.fetchUserCredit()
                } else {
                    userRef.setData([
                        "Credit": 0
                    ], merge: true) { error in
                        if let error = error {
                        } else {
                            self.fetchUserCredit()
                        }
                    }
                }
            }
        }
    }

    public static func configure(prizeAmount: Int,
                          prizeTerminology: String,
                          primaryTextColor: UIColor,
                          mainColor: UIColor,
                          secondaryTextColor: UIColor,
                          backgroundColor: UIColor,
                          containerColor: UIColor,
                          buttonTextColor: UIColor) {
        setDatabase()
        
        NeonReferralConstants.prizeAmount = prizeAmount
        NeonReferralConstants.prizeTerminology = prizeTerminology
        NeonReferralConstants.mainColor = mainColor
        NeonReferralConstants.primaryTextColor = primaryTextColor
        NeonReferralConstants.secondaryTextColor = secondaryTextColor
        NeonReferralConstants.buttonTextColor = buttonTextColor
        NeonReferralConstants.backgroundColor = backgroundColor
        NeonReferralConstants.containerColor = containerColor
       }

    private static func fetchUserCredit(){
        NeonReferralDatabase.shared.fetchUserCredit() { credit, error in
               if let error = error {
                   print("Error fetching document: \(error)")
               } else if let credit = credit {
                   print("User credit : \(credit)")
                   NeonReferralConstants.remainingCredit = Int(credit)
               } else {
                   print("Document does not exist or `Credit` field is missing.")
               }
           }
    }
    public static func useCredit(amount: Int, completion: @escaping (Bool, String?) -> Void) {
        let currentCredit = NeonReferralConstants.remainingCredit
        if currentCredit == 0 {
            completion(false, "No credit left")
        } else if currentCredit < amount {
            completion(false, "You don't have enough credit")
        } else {
            guard let userID = AuthManager.currentUserID else {
                completion(false, "User ID not found")
                return
            }
            NeonReferralDatabase.shared.decreaseCredit(userId: userID, amount: amount)
            NeonReferralConstants.remainingCredit -= amount
            print(NeonReferralConstants.remainingCredit)
            completion(true, nil)
        }
    }

    public static func earnCredit(amount : Int){
        guard let userID = AuthManager.currentUserID else { return }
        NeonReferralDatabase.shared.addCredit(for: userID, amount: amount)
        NeonReferralConstants.remainingCredit += amount
        print(NeonReferralConstants.remainingCredit)
    }
    
    private func custom(presentingVC: UIViewController, destinationVC: UIViewController, height: Int , cornerRadius: Int ) {
        DispatchQueue.main.async {
            destinationVC.modalPresentationStyle = .formSheet
            if let sheet = destinationVC.sheetPresentationController {
                sheet.detents = [.custom { _ in
                    return CGFloat(height)
                }]
                sheet.preferredCornerRadius = CGFloat(cornerRadius)
                sheet.prefersGrabberVisible = true
            }
            presentingVC.present(destinationVC, animated: true, completion: nil)
        }
    }
}
