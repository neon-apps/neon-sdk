//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 14.07.2024.
//

import Foundation
import Adapty
import UIKit

class AdaptyBuilderManager : NSObject{
    
    static let shared = AdaptyBuilderManager()
    
    @available(iOS 15.0, *)
    public func presentAdaptyBuilderPaywall(paywall : AdaptyPaywall, from controller : UIViewController){
        
        for adaptyBuilderPaywall in adaptyBuilderPaywalls {
            if adaptyBuilderPaywall.paywall.placementId == paywall.placementId{
                
                guard paywall.hasViewConfiguration else {
                    //  use your custom logic
                    print("This paywall does not contain viewConfiguration")
                      return
                }
                
                let visualPaywall = try! AdaptyUI.paywallController(
                    for: adaptyBuilderPaywall.paywall,
                    products: nil,
                    viewConfiguration: adaptyBuilderPaywall.configuration,
                    delegate: self as! AdaptyPaywallControllerDelegate
                )
                controller.present(visualPaywall, animated: true)
                
            }
        }
    
    }
    
    
}
@available(iOS 15.0, *)
extension AdaptyBuilderManager{
    public func paywallControllerDidStartRestore(_ controller: AdaptyPaywallController) {
        
    }
    public func paywallController(_ controller: AdaptyPaywallController, didFailPurchase product: AdaptyPaywallProduct, error: AdaptyError) {
        
    }
    
    public func paywallController(_ controller: AdaptyPaywallController, didSelectProduct product: AdaptyPaywallProduct) {
        
    }
    
    public func paywallController(_ controller: AdaptyPaywallController, didStartPurchase product: AdaptyPaywallProduct) {
        
    }
    
    public func paywallController(_ controller: AdaptyPaywallController, didCancelPurchase product: AdaptyPaywallProduct) {
        
    }
    
    public func paywallController(_ controller: AdaptyPaywallController, didFailRestoreWith error: AdaptyError) {
        
    }
    
    public func paywallController(_ controller: AdaptyPaywallController, didFailRenderingWith error: AdaptyError) {
        
    }
    
    public func paywallController(_ controller: AdaptyPaywallController, didFailLoadingProductsWith error: AdaptyError) -> Bool {
        return true
    }
    public func paywallController(_ controller: AdaptyPaywallController,
                           didPerform action: AdaptyUI.Action) {

        switch action {
            case .close:
                controller.dismiss(animated: true)
            case let .openURL(url):
                      // handle URL opens (incl. terms and privacy links)
                UIApplication.shared.open(url, options: [:])
            case let .custom(id):
                if id == "login" {
                   // implement login flow
                }
                break
        }
    }
    
    public func paywallController(_ controller: AdaptyPaywallController,
                           didFinishPurchase product: AdaptyPaywallProduct,
                           purchasedInfo: AdaptyPurchasedInfo) {
        controller.dismiss(animated: true)
    }
    public func paywallController(_ controller: AdaptyPaywallController,
                           didFinishRestoreWith profile: AdaptyProfile) {
    }
    
}

public class AdaptyBuilderPaywall{
    var paywall : AdaptyPaywall
    var configuration : AdaptyUI.LocalizedViewConfiguration
    var packages : [AdaptyPaywallProduct]
    
    init(paywall: AdaptyPaywall, configuration: AdaptyUI.LocalizedViewConfiguration, packages: [AdaptyPaywallProduct]) {
        self.paywall = paywall
        self.configuration = configuration
        self.packages = packages
    }
}
