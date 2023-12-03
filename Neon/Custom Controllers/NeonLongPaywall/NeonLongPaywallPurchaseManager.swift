//
//  NeonLongPaywallPurchaseManager.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 3.12.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallPurchaseManager{
    
    static func subscribe(completionSuccess : @escaping () -> ()){
        let plan = NeonLongPaywallConstants.selectedPlan
        
        if let adaptyPackage = AdaptyManager.getPackage(id: plan.productIdentifier){
            
            let product = adaptyPackage.skProduct
            
            AdaptyManager.selectPackage(id: product.productIdentifier)
            
            AdaptyManager.purchase(animation: .loadingCircle, animationColor: NeonLongPaywallConstants.mainColor) {
                completionSuccess()
                } completionFailure: {
                    
                }
           

        }else if let revenueCatPackage = RevenueCatManager.getPackage(id: plan.productIdentifier), let product = revenueCatPackage.storeProduct.sk1Product{
       
            RevenueCatManager.selectPackage(id: product.productIdentifier)
            
            RevenueCatManager.purchase(animation: .loadingCircle, animationColor: NeonLongPaywallConstants.mainColor) {
                completionSuccess()
                } completionFailure: {
                    
                }
            
        }else{
  
        }
    }
    
    static func restore(controller : UIViewController, completionSuccess : @escaping () -> ()){
        
        let provider = NeonLongPaywallConstants.provider
        switch provider {
        case .adapty:
            AdaptyManager.restorePurchases(
                vc: controller,
                animation: .loadingCircle, animationColor: NeonLongPaywallConstants.mainColor) {
                    completionSuccess()
                } completionFailure: {
                    
                }
        case .revenuecat:
            RevenueCatManager.restorePurchases(
                vc: controller,
                animation: .loadingCircle, animationColor: NeonLongPaywallConstants.mainColor) {
                    completionSuccess()
                } completionFailure: {
                    
                }

        }
    }
}
