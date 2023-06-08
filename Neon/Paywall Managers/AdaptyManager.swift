//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 7.06.2023.
//

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

    
    public static func configure(withAPIKey : String, paywallIDs : [String]) {
        Adapty.activate(withAPIKey)
        fetchPaywalls(paywallIDs: paywallIDs)
        verifySubscription(completionSuccess: nil, completionFailure: nil)
        configureNotification()
    }
    
    
    private static func fetchPaywalls(paywallIDs : [String]){
        for paywallID in paywallIDs{
            fetchPaywall(id: paywallID)
        }
    }
    private static func fetchPaywall(id : String){
        
        let locale = Locale.current.identifier
        Adapty.getPaywall(id, locale: locale) { result in
            switch result {
            case let .success(paywall):
                paywalls.append(paywall)
                fetchPackages(paywall: paywall)
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
    
    public static func getPaywall(id : String) -> AdaptyPaywall?{
        for paywall in paywalls {
            if paywall.id == id{
                return paywall
            }
        }
        
        return nil
    }
    
    public static func getRemoteConfigValue(id : String) -> Any?{
        if let remoteConfig = selectedPaywall?.remoteConfig{
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
    
    public static func selectPackage(id : String){
        for package in packages {
            if package.vendorProductId == id{
                AdaptyManager.selectedPackage = package
                return
            }
        }
    }
    
    
    
    
    public static func subscribe(animation : LottieManager.AnimationType, animationColor : UIColor? = nil, animationWidth : Int? = nil,  completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        LottieManager.showFullScreenLottie(animation: animation, width : animationWidth, color: animationColor)
        guard let package = AdaptyManager.selectedPackage else {
            LottieManager.removeFullScreenLottie()
            return }

        Adapty.makePurchase(product: package) { result in
            switch result {
            case let .success(profile):
                if profile.accessLevels["pro"]?.isActive ?? false {
                    Neon.isUserPremium = true
                    UserDefaults.standard.setValue(Neon.isUserPremium, forKey: "Neon-IsUserPremium")
                    guard let completionSuccess else { return }
                    completionSuccess()
                } else {
                    guard let completionFailure else { return }
                    completionFailure()
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
            switch result {
            case let .success(profile):
                if profile.accessLevels["pro"]?.isActive ?? false {
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
              
                }else{
                    
                    if showAlerts{
                        AlertManager.showCustomAlert(title: "Oops!", message: "We couldn’t find any active subscription in your account.", style: .alert, buttons: [
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
                    AlertManager.showCustomAlert(title: "Oops!", message: "Something went wrong, please try again later", style: .alert, buttons: [
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
                   profile.accessLevels["pro"]?.isActive ?? false {
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
}


