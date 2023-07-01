//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 28.03.2023.
//

import Foundation
import UIKit
import StoreKit

public class Helpers{
    
    
    public static func share(items : [NSObject], vc : UIViewController){
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view
        vc.present(activityViewController, animated: true, completion: nil)
    }
#if !os(xrOS)
    public static func showRatePopup() {
        SKStoreReviewController.requestReviewInCurrentScene()
    }

    public static func openWithBrowser(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
#endif
    
}
