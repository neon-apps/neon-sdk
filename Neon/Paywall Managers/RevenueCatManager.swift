//
//  RevenueCatManager.swift
//  
//
//  Created by Tuna Öztürk on 11.03.2023.
//
#if !os(xrOS)
import RevenueCat
import StoreKit
import UIKit
import Lottie


public protocol RevenueCatManagerDelegate: AnyObject {
    func packageFetched()
}

@available(iOS 13.0, *)
public class RevenueCatManager {

    public static var packages = [Package]()
    public static var delegate: RevenueCatManagerDelegate?
    public static var selectedPackage : Package?
    private static var accessLevel = String()
    
    public static func configure(withAPIKey : String, accessLevel : String = "pro") {
        self.accessLevel = accessLevel
        Purchases.configure(withAPIKey: withAPIKey)
        fetchPackages()
        verifySubscription(completionSuccess: nil, completionFailure: nil)
        configureNotification()
    }
    
    internal static func fetchPackages() {
        Purchases.shared.getOfferings { offerings, _ in

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
    
    
    
    
    public static func purchase(animation : LottieManager.AnimationType, animationColor : UIColor? = nil, animationWidth : Int? = nil,  completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation, width : animationWidth, color: animationColor)
        guard let package = RevenueCatManager.selectedPackage else {
            LottieManager.removeFullScreenLottie()
            return }
        
        Purchases.shared.purchase(package: package) {  transaction, purchaserInfo, error, _ in
            LottieManager.removeFullScreenLottie()
            
            if NeonPaywallManager.isSubscription(product: package.storeProduct.sk1Product){
                
                
                if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                    Neon.isUserPremium = true
                    UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                    guard let completionSuccess else { return }
                    completionSuccess()
                } else {
                    guard let completionFailure else { return }
                    completionFailure()
                }
                
            }else{
                if error == nil{
                    guard let completionSuccess else { return }
                    completionSuccess()
                } else {
                    guard let completionFailure else { return }
                    completionFailure()
                }
            }
            
            
            
        }
    }
    
    
    
    
    public static func restorePurchases(vc: UIViewController, animation : LottieManager.AnimationType, animationColor : UIColor? = nil, animationWidth : Int? = nil, showAlerts : Bool = true, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation, width : animationWidth, color: animationColor)

        Purchases.shared.restorePurchases {  purchaserInfo, _ in
            LottieManager.removeFullScreenLottie()
            if purchaserInfo?.entitlements.all[accessLevel]?.isActive == true {
                Neon.isUserPremium = true
                UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                
                if showAlerts{
                    NeonAlertManager.default.present(title: "Restored Succesfully!", message: "Welcome back! We restored your subscription succesfully. Now you can use all of the premium features again.", style: .alert, buttons: [
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
                    NeonAlertManager.default.present(title: "Oops!", message: "We couldn’t find any active subscription in your account.", style: .alert, buttons: [
                        AlertButton(completion: {
                            guard let completionFailure else { return }
                            completionFailure()
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
            if purchaserInfo?.entitlements.all[accessLevel]?.isActive == true {
                Neon.isUserPremium = true
                UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                guard let completionSuccess else { return }
                completionSuccess()
            } else {
                if !Neon.isPremiumTestActive{
                    Neon.isUserPremium = false
                    UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                }
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
    
    @available(*, unavailable, renamed: "purchase")
    public static func subscribe(animation : LottieManager.AnimationType, animationColor : UIColor? = nil, animationWidth : Int? = nil,  completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {}
}


#endif
