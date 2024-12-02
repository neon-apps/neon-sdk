//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 14.07.2024.
//

import Foundation
import Adapty
import UIKit
import AdaptyUI

public class AdaptyBuilderManager : NSObject, AdaptyPaywallControllerDelegate{
    
    public static let shared = AdaptyBuilderManager()
    
    var purchased: ((_ product : AdaptyPaywallProduct?) -> ())? = nil
    var dismissed: (() -> ())? = nil
    var restored: (() -> ())? = nil
    @available(iOS 15.0, *)
    public func present(
        paywall : AdaptyPaywall,
        from controller : UIViewController,
        purchased: @escaping (_ product : AdaptyPaywallProduct?) -> (),
        dismissed: @escaping () -> (),
        restored: @escaping () -> (),
        failedToPresent: @escaping () -> ()
    ){
        
        self.purchased = purchased
        self.dismissed = dismissed
        self.restored = restored
        
        if !AdaptyManager.adaptyBuilderPaywalls.contains(where: {$0.paywall.placementId == paywall.placementId}){
            failedToPresent()
            return
        }
        for adaptyBuilderPaywall in AdaptyManager.adaptyBuilderPaywalls {
            if adaptyBuilderPaywall.paywall.placementId == paywall.placementId{
                
                guard paywall.hasViewConfiguration else {
                    //  use your custom logic
                    print("This paywall does not contain viewConfiguration")
                    failedToPresent()
                      return
                }
                
                NeonAppTracking.trackPaywallView()
                
                let visualPaywall = try! AdaptyUI.paywallController(
                    for: adaptyBuilderPaywall.paywall,
                    products: nil,
                    viewConfiguration: adaptyBuilderPaywall.configuration,
                    delegate: self
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
            if let dismissed{
                dismissed()
            }
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
        Neon.isUserPremium = true
      
        NeonPaywallManager.trackPurchase(product: product.skProduct)
        
        controller.dismiss(animated: true)
        
        if let purchased{
            purchased(product)
        }
       
    }
    public func paywallController(_ controller: AdaptyPaywallController,
                           didFinishRestoreWith profile: AdaptyProfile) {
      
        controller.dismiss(animated: true)
        if profile.accessLevels[AdaptyManager.accessLevel]?.isActive ?? false {
            Neon.isUserPremium = true
            if let restored{
                restored()
            }

        }
        
      
       
       
       
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
