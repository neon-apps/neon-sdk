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
    public static var delegate: RevenueCatManagerDelegate?
    internal static var selectedPackage : Package?
    
    public static func configure(withAPIKey : String,
                            products : [String]) {
        Purchases.configure(withAPIKey: withAPIKey)
        fetchPackages(products: products)
        verifySubscription(completionSuccess: nil, completionFailure: nil)
        configureNotification()
    }
    
    internal static func fetchPackages(products : [String]) {
        Purchases.shared.getOfferings { [self] offerings, _ in

            if let offerings = offerings {
                let offer = offerings.current
                let packages = offer?.availablePackages
                
                guard packages != nil else {
                    return
                }
                for package in packages! {
                    RevenueCatManager.packages.append(package)
                    UserDefaults.standard.setValue(package.localizedPriceString, forKey: "Neon-\(package.storeProduct.productIdentifier)")
                    RevenueCatManager.delegate?.packageFetched()
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
    
    public static func getPackagePrice(id : String) -> String?{
        for package in packages {
            if package.storeProduct.productIdentifier == id{
                return package.localizedPriceString
            }else{
                return UserDefaults.standard.string(forKey: "Neon-\(id)")
            }
        }
        
        return UserDefaults.standard.string(forKey: "Neon-\(id)")
    }
    
    public static func selectPackage(id : String){
        for package in packages {
            if package.storeProduct.productIdentifier == id{
                RevenueCatManager.selectedPackage = package
                return
            }
        }
        

    }
    
    
    
    
    public static func subscribe(animation : LottieManager.AnimationType, animationColor : UIColor = UIColor.clear, animationWidth : Int? = nil,  completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation, width : animationWidth, color: animationColor)
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
    
    public static func purchase(animation : LottieManager.AnimationType, animationColor : UIColor = UIColor.clear, animationWidth : Int? = nil, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation, width : animationWidth, color: animationColor)
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
    
    
    
    public static func restorePurchases(vc: UIViewController, animation : LottieManager.AnimationType, animationColor : UIColor = UIColor.clear, animationWidth : Int? = nil, showAlerts : Bool = true, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation, width : animationWidth, color: animationColor)

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
    
    internal static func configureNotification(){
        NotificationCenter.observe(name: UIApplication.willEnterForegroundNotification) { Notification in
            RevenueCatManager.verifySubscription(completionSuccess: nil, completionFailure: nil)
        }
    }
}


