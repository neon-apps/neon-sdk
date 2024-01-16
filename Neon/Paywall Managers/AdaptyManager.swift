//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 7.06.2023.
//
#if !os(xrOS)
import Foundation
import Adapty
import StoreKit
import UIKit
import Lottie


public protocol AdaptyManagerDelegate: AnyObject {
    func packageFetched()
}

@available(iOS 13.0, *)
public class AdaptyManager {

    public static var paywalls = [AdaptyPaywall]()
    public static var packages = [AdaptyPaywallProduct]()
    
    public static var selectedPaywall : AdaptyPaywall?
    public static var selectedPackage : AdaptyPaywallProduct?
    
    
    public static var delegate: AdaptyManagerDelegate?
    private static var accessLevel = String()

    
  
 
    
    public static func configure(withAPIKey : String, placementIDs : [String], accessLevel : String = "premium", completion : (() -> ())? = nil) {
        self.accessLevel = accessLevel
        Adapty.activate(withAPIKey)
        fetchPaywalls(paywallIDs: placementIDs,completion: completion)
        verifySubscription(completionSuccess: nil, completionFailure: nil)
        configureNotification()
    }
    
    
    private static func fetchPaywalls(paywallIDs : [String], completion : (() -> ())? = nil){
        var fetchedPaywallCount = 0
        for paywallID in paywallIDs{
            fetchPaywall(id: paywallID,completion: {
                fetchedPaywallCount += 1
                if fetchedPaywallCount == paywallIDs.count{
                    if let completion{
                        completion()
                    }
                }
            })
        }
    }
    private static func fetchPaywall(id : String,  completion : (@escaping () -> ())){
        
        let locale = Locale.current.identifier
        Adapty.getPaywall(placementId: id, locale: locale) { result in
            switch result {
            case let .success(paywall):
                paywalls.append(paywall)
                fetchPackages(paywall: paywall)
                completion()
                break
                // the requested paywall
            case let .failure(error):
                break
                // handle the error
            }
        }
        
    }
    
    
    private static func fetchPackages(paywall : AdaptyPaywall){
        Adapty.getPaywallProducts(paywall: paywall) { result in
            switch result {
            case let .success(packages):
                for package in packages{
                    if !self.packages.contains(where: {$0.vendorProductId == package.vendorProductId}){
                        self.packages.append(package)
                        UserDefaults.standard.setValue(package.localizedPrice, forKey: "Neon-\(package.vendorProductId)")
                        AdaptyManager.delegate?.packageFetched()
                    }
                }
                break
                // the requested packages array
            case let .failure(error):
                break
                // handle the error
            }
        }
    }

    
    public static func getPackage(id : String) -> AdaptyPaywallProduct?{
        for package in packages {
            if package.vendorProductId == id{
                return package
            }
        }
        
        return nil
    }
    
    public static func getPackage(index : Int) -> AdaptyPaywallProduct?{
        
        if packages.count > index{
            return packages[index]
        }else{
            return nil
        }
    }
    
    public static func getPaywall(placementID : String) -> AdaptyPaywall?{
        for paywall in paywalls {
            if paywall.placementId == placementID{
                return paywall
            }
        }
        
        return nil
    }
    public static func selectPaywall(placementID : String){
        selectedPaywall = getPaywall(placementID: placementID)
    }
    
    
    public static func getRemoteConfigValue(id : String) -> Any?{
        
        guard let selectedPaywall else{
            fatalError("Currently you didn't set any paywall as selected. If you need to use remoteConfig, you have to select the paywall with it's placement ID in the first line of viewDidLoad of the paywall. Use AdaptyManager.selectPaywall function to set selected paywall.")
        }
        if let remoteConfig = selectedPaywall.remoteConfig{
            let value = remoteConfig[id]
            UserDefaults.standard.set(value, forKey: "Neon-Adapty-\(id)")
            return value
        }
        return UserDefaults.standard.value(forKey: "Neon-Adapty-\(id)")
    }
    
    
    public static func getPackagePrice(id : String) -> String{
        for package in packages {
            if package.vendorProductId == id{
                return package.localizedPrice ?? "..."
            }else{
                return UserDefaults.standard.string(forKey: "Neon-\(id)") ?? "..."
            }
        }
        
        return UserDefaults.standard.string(forKey: "Neon-\(id)") ?? "..."
    }
    
    public static func getPrice(package : AdaptyPaywallProduct) -> String{
        return package.localizedPrice ?? "..."
    }
    
    public static func selectPackage(id : String){
        for package in packages {
            if package.vendorProductId == id{
                AdaptyManager.selectedPackage = package
                return
            }
        }
    }
    
    
    
    
    public static func purchase(animation : LottieManager.AnimationType, animationColor : UIColor? = nil, animationWidth : Int? = nil,  completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation, width : animationWidth, color: animationColor)
        guard let package = AdaptyManager.selectedPackage else {
            LottieManager.removeFullScreenLottie()
            return }

        Adapty.makePurchase(product: package) { result in
            LottieManager.removeFullScreenLottie()
            switch result {
            case let .success(purchaseInfo):
                
                if NeonPaywallManager.isSubscription(product: package.skProduct){
                    if purchaseInfo.profile.accessLevels[self.accessLevel]?.isActive ?? false {
                        Neon.isUserPremium = true
                        UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                        guard let completionSuccess else { return }
                        completionSuccess()
                    } else {
                        guard let completionFailure else { return }
                        completionFailure()
                    }
                    
                }else{
                    guard let completionSuccess else { return }
                    completionSuccess()
                    break
                }
          
                break
                // successful purchase
            case let .failure(error):
                guard let completionFailure else { return }
                completionFailure()
                break
                // handle the error
            }
        }
        
    }
    
 

    
    public static func restorePurchases(vc: UIViewController, animation : LottieManager.AnimationType, animationColor : UIColor? = nil, animationWidth : Int? = nil, showAlerts : Bool = true, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        
        
        LottieManager.showFullScreenLottie(animation: animation, width : animationWidth, color: animationColor)

        Adapty.restorePurchases {  result in
            LottieManager.removeFullScreenLottie()
            switch result {
            case let .success(profile):
                if profile.accessLevels[self.accessLevel]?.isActive ?? false {
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
              
                }else{
                    
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
                break
                // check the access level
            case let .failure(error):
                NeonAlertManager.default.present(title: "Oops!", message: "Something went wrong, please try again later", style: .alert, buttons: [
                        AlertButton(completion: {
                            guard let completionFailure else { return }
                            completionFailure()
                        })
                    ], viewController: vc)
                print("Adapty Error", error)
                break
                // handle the error
            }
        }
    }
    
    public static func verifySubscription(completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        
            Adapty.getProfile { result in
                if let profile = try? result.get(),
                   profile.accessLevels[self.accessLevel]?.isActive ?? false {
                    Neon.isUserPremium = true
                    UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                    guard let completionSuccess else { return }
                    completionSuccess()
                }else {
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
            AdaptyManager.verifySubscription(completionSuccess: nil, completionFailure: nil)
        }
    }
    
    
    
    
    
    
    @available(*, deprecated, renamed: "configure(withAPIKey:placementIDs:)")
    public static func configure(withAPIKey: String, paywallIDs: [String], accessLevel: String = "premium") {
        configure(withAPIKey: withAPIKey, placementIDs: paywallIDs, accessLevel: accessLevel)
    }
    @available(*, deprecated, renamed: "getPaywall(placementID:)")
    public static func getPaywall(id : String) -> AdaptyPaywall?{
        for paywall in paywalls {
            if paywall.placementId == id{
                return paywall
            }
        }
        
        return nil
    }
    
    @available(*, unavailable, renamed: "purchase")
    public static func subscribe(animation : LottieManager.AnimationType, animationColor : UIColor? = nil, animationWidth : Int? = nil,  completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        
    }
}


#endif
