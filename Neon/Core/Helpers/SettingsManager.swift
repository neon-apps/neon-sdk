//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 26.05.2023.
//

import Foundation
import UIKit
import StoreKit
@available(iOS 13.0, *)
public class SettingsManager{
    
    
    public static func shareApp(appID : String, vc : UIViewController){
        if let name = URL(string: "https://apps.apple.com/app/id\(appID)"), !name.absoluteString.isEmpty {
            let itemsToShare = [name]
            let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            vc.present(activityVC, animated: true, completion: nil)
        } else {
        }
    }
    
    public static func presentLegalController(onVC : UIViewController,
                                  type : NeonLegalController.LegalControllerType,
                                  backgroundColor : UIColor,
                                  headerColor : UIColor,
                                  titleColor : UIColor,
                                  textColor : UIColor){
        let legalController = NeonLegalController()
        legalController.controllerType = type
        legalController.backgroundColor = backgroundColor
        legalController.headerColor = headerColor
        legalController.titleColor = titleColor
        legalController.legalTextColor = textColor
        onVC.present(destinationVC: legalController, slideDirection: .right)
    }
    
    public static func presentSupportController(onVC : UIViewController,
                                                type : NeonSupportControllerConstants.ControllerType,
                                  mainColor : UIColor,
                                  backgroundColor : UIColor,
                                  containerColor : UIColor,
                                  textColor : UIColor,
                                  placeholderColor : UIColor,
                                  buttonTextColor : UIColor = .white,
                                  textButtonColor : UIColor = .white){
        let supportController = NeonSupportController()
        NeonSupportControllerConstants.choosenControllerType = type
        NeonSupportControllerConstants.backgroundColor = backgroundColor
        NeonSupportControllerConstants.containerColor = containerColor
        NeonSupportControllerConstants.placeholderColor = placeholderColor
        NeonSupportControllerConstants.mainColor = mainColor
        NeonSupportControllerConstants.textColor = textColor
        NeonSupportControllerConstants.buttonTextColor = buttonTextColor
        NeonSupportControllerConstants.textButtonColor = textButtonColor
        onVC.present(destinationVC: supportController, slideDirection: .right)
    }
    
    
#if !os(xrOS)
    public static func showReviewSheet(appID : String){
        if let checkURL = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review") {
            open(url: checkURL)
        } else {
            SKStoreReviewController.requestReviewInCurrentScene()
        }
    }

    public static func openLinkFromBrowser(url: String) {
        guard let url = URL(string: url) else { return}
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:])
        }
      }
    
    static func open(url: URL) {
        if #available(iOS 10, *) {
          UIApplication.shared.open(url, options: [:], completionHandler: { success in
            print("Open \(url): \(success)")
            if !success{
              SKStoreReviewController.requestReviewInCurrentScene()
            }
          })
        } else if UIApplication.shared.openURL(url) {
          print("Open \(url)")

        }
      }
#endif
}
