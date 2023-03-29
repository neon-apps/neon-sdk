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

    public static var packages = [Package]()
    weak var delegate: RevenueCatManagerDelegate?
    internal static var selectedPackage : Package?
    
    public static func configure(withAPIKey : String,
                            products : [String]) {
        Purchases.configure(withAPIKey: withAPIKey)
        RevenueCatManager().fetchPackages(products: products)
        RevenueCatManager.verifySubscription(completionSuccess: nil, completionFailure: nil)
 
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
                    RevenueCatManager.packages.append(package)
                    self.delegate?.packageFetched()
                }
            }
        }
    }
    
    public static func getPackage(id : String) -> Package?{
        for package in packages {
            if package.storeProduct.productIdentifier == id{
                return package
            }
        }
        
        return nil
    }
    
    
    
    public static func subscribe(animation : LottieManager.AnimationType, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation)
        guard let package = RevenueCatManager.selectedPackage else {
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
    
    public static func purchase(animation : LottieManager.AnimationType, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation)
        guard let package = RevenueCatManager.selectedPackage else {
            LottieManager.removeFullScreenLottie()
            return }
        
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
    
    
    public static func restorePurchases(vc: UIViewController, animation : LottieManager.AnimationType, showAlerts : Bool = true, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation)

        Purchases.shared.restorePurchases {  purchaserInfo, _ in
            LottieManager.removeFullScreenLottie()
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                Neon.isUserPremium = true
                UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                
                if showAlerts{
                    AlertManager.showCustomAlert(title: "Restored Succesfully!", message: "Welcome back! We restored your subscription succesfully. Now you can use all of the premium features again.", style: .alert, buttons: [
                        AlertButton(completion: {
                            guard let completionSuccess else { return }
                            completionSuccess()
                        })
                    ], viewController: vc)
                }else{
                    guard let completionSuccess else { return }
                    completionSuccess()
                }
          
            } else {
                
                if showAlerts{
                    AlertManager.showCustomAlert(title: "Oops!", message: "We couldn’t find any active subscription in your account.", style: .alert, buttons: [
                        AlertButton(completion: {
                            guard let completionSuccess else { return }
                            completionSuccess()
                        })
                    ], viewController: vc)
                }else{
                    guard let completionFailure else { return }
                    completionFailure()
                }
            }
        }
    }
    
    public static func verifySubscription(completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
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

extension Package{
    
    func selectPackage(){
        RevenueCatManager.selectedPackage = self
    }
}
