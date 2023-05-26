//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 26.05.2023.
//

import Foundation
import UIKit
import StoreKit
public class SettingsManager{
    
    
    public func shareApp(appID : String, vc : UIViewController){
        if let name = URL(string: "https://apps.apple.com/app/id\(appID)"), !name.absoluteString.isEmpty {
            let itemsToShare = [name]
            let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
            vc.present(activityVC, animated: true, completion: nil)
        } else {
        }
    }
    
    public func showReviewSheet(appID : String){
        if let checkURL = URL(string: "itms-apps://itunes.apple.com/app/id\(appID)?action=write-review") {
            open(url: checkURL)
        } else {
            SKStoreReviewController.requestReviewInCurrentScene()
        }
    }
    
    static func openLinkFromBrowser(_ url: String) {
        guard let url = URL(string: url) else { return}
        if UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:])
        }
      }
    
    func open(url: URL) {
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
}
