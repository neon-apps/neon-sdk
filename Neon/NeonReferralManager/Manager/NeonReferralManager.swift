//
//  NeonReferralManager.swift
//  PromotionCode
//
//  Created by cihangirincaz on 1.08.2024.
//

import UIKit
import NeonSDK
import FirebaseFirestore

@available(iOS 16.0, *)
public class NeonReferralManager {
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
        reddemVC.modalPresentationStyle = .formSheet
        if let sheet = reddemVC.sheetPresentationController {
            sheet.detents = [.custom { _ in
                return CGFloat(224)
            }]
            sheet.preferredCornerRadius = CGFloat(24)
            sheet.prefersGrabberVisible = true
        }
        viewController.present(reddemVC, animated: true, completion: nil)
        
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
                                 mainColor: UIColor,
                                 primaryTextColor: UIColor,
                                 secondaryTextColor: UIColor,
                                 buttonTextColor: UIColor,
                                 backgroundColor: UIColor,
                                 containerColor: UIColor,
                                 appId : String,
                                 overrideUserInterfaceStyle : UIUserInterfaceStyle = .light) {
        setDatabase()
        
        NeonReferralConstants.prizeAmount = prizeAmount
        NeonReferralConstants.prizeTerminology = prizeTerminology
        NeonReferralConstants.mainColor = mainColor
        NeonReferralConstants.primaryTextColor = primaryTextColor
        NeonReferralConstants.secondaryTextColor = secondaryTextColor
        NeonReferralConstants.buttonTextColor = buttonTextColor
        NeonReferralConstants.backgroundColor = backgroundColor
        NeonReferralConstants.containerColor = containerColor       
        NeonReferralConstants.appId = appId
        NeonReferralConstants.overrideUserInterfaceStyle = overrideUserInterfaceStyle
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
    public static func useCredit(amount: Int) {
        let currentCredit = NeonReferralConstants.remainingCredit
        NeonReferralDatabase.shared.decreaseCredit(userId: userID, amount: amount)
        NeonReferralConstants.remainingCredit -= amount
        }
    }
    
    public static func earnCredit(amount : Int){
        guard let userID = AuthManager.currentUserID else { return }
        NeonReferralDatabase.shared.addCredit(for: userID, amount: amount)
        NeonReferralConstants.remainingCredit += amount
    }
    
    
}
