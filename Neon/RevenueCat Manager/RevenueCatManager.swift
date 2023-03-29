//
//  RevenueCatManager.swift
//  
//
//  Created by Tuna Öztürk on 11.03.2023.
//

import RevenueCat
import StoreKit
import UIKit
import Lottie


public protocol RevenueCatManagerDelegate: AnyObject {
    func packageFetched()
}

public class RevenueCatManager {
    public static let shared = RevenueCatManager()
    
    var loadingAnimation = String()
    var monthlyProductID = String()
    var weeklyProductID = String()
    var packages = [Package]()
    
    weak var delegate: RevenueCatManagerDelegate?
    
    
    public func configureRC(withAPIKey : String,
                            products : [String]) {
        Purchases.configure(withAPIKey: withAPIKey)
        fetchPackages(products: products)
        verifySubscription(completionSuccess: nil, completionFailure: nil)
 
    }
    
    func fetchPackages(products : [String]) {
        Purchases.shared.getOfferings { [self] offerings, _ in

            if let offerings = offerings {
                let offer = offerings.current
                let packages = offer?.availablePackages
                
                guard packages != nil else {
                    return
                }
                for package in packages! {
                    self.packages.append(package)
                    self.delegate?.packageFetched()
                }
            }
        }
    }
    
    func getPackage(id : String) -> Package?{
        for package in packages {
            if package.storeProduct.productIdentifier == id{
                return package
            }
        }
        
        return nil
    }
    
    
    
    func subscribe(package: Package?, vc: UIViewController, animation : LottieManager.AnimationType, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation)
        guard let package else {
            LottieManager.removeFullScreenLottie()
            return }
        
        Purchases.shared.purchase(package: package) {  transaction, purchaserInfo, _, _ in
            LottieManager.removeFullScreenLottie()
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                Neon.isUserPremium = true
                UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                guard let completionSuccess else { return }
                completionSuccess()
            } else {
                guard let completionFailure else { return }
                completionFailure()
            }
        }
    }
    
    func purchase(package: Package?, vc: UIViewController, animation : LottieManager.AnimationType, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation)
        guard let package else { return }
        
        Purchases.shared.purchase(package: package) {  transaction, purchaserInfo, error, _ in
            LottieManager.removeFullScreenLottie()
            if error == nil{
                guard let completionSuccess else { return }
                completionSuccess()
            } else {
                guard let completionFailure else { return }
                completionFailure()
            }
        }
    }
    
    
    func restorePurchases(vc: UIViewController, animation : LottieManager.AnimationType, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation)

        Purchases.shared.restorePurchases {  purchaserInfo, _ in
            LottieManager.removeFullScreenLottie()
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                Neon.isUserPremium = true
                UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                guard let completionSuccess else { return }
                completionSuccess()
            } else {
                guard let completionFailure else { return }
                completionFailure()
            }
        }
    }
    
    func verifySubscription(completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        Purchases.shared.getCustomerInfo { purchaserInfo, _ in
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                Neon.isUserPremium = true
                UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                guard let completionSuccess else { return }
                completionSuccess()
            } else {
                Neon.isUserPremium = false
                UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                guard let completionFailure else { return }
                completionFailure()
            }
        }
    }

}
