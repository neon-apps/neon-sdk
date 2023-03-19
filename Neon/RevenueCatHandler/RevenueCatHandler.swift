//
//  RevenueCatHandler.swift
//  
//
//  Created by Tuna Öztürk on 11.03.2023.
//

import RevenueCat
import StoreKit
import UIKit
import Lottie

public class RevenueCatHandler {
    public static let shared = RevenueCatHandler()
    
    var loadingAnimation = String()
    var monthlyProductID = String()
    var weeklyProductID = String()
    var annualProductID = String()
    
    var packageMonthly: Package?
    var packageWeekly: Package?
    var packageAnnual: Package?

    var isUserPremium = Bool()
    
    public func configureRC(withAPIKey : String,
                     loadingAnimation : String,
                     weeklyProductID : String = "",
                     monthlyProductID : String = "",
                     annualProductID : String = "") {
        self.loadingAnimation = loadingAnimation
        self.weeklyProductID = weeklyProductID
        self.monthlyProductID = monthlyProductID
        self.annualProductID = annualProductID
        Purchases.configure(withAPIKey: withAPIKey)
        fetchPackages()
    }
    
    func fetchPackages() {
        Purchases.shared.getOfferings { [self] offerings, _ in

            if let offerings = offerings {
                let offer = offerings.current
                let packages = offer?.availablePackages
                
                guard packages != nil else {
                    return
                }
                for package in packages! {
                    let product = package.storeProduct
                    let productPrice = product.price
                    switch product.productIdentifier {
                    case self.weeklyProductID:
                        packageWeekly = package
                    case self.monthlyProductID:
                        packageMonthly = package
                        NotificationCenter.default.post(name: Notification.Name("PricesReady"), object: nil)
                    case self.annualProductID:
                        packageAnnual = package
                    default:
                        return
                    }
                }
            }
        }
    }
    
    func purchasePackage(package: Package?, vc: UIViewController, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        let viewLoading = createLoadingPurchaseView(view: vc.view)
        vc.view.addSubview(viewLoading)
        guard let package else { return }
        
        Purchases.shared.purchase(package: package) {  transaction, purchaserInfo, _, _ in
            viewLoading.removeFromSuperview()
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                self.isUserPremium = true
                guard let completionSuccess else { return }
                completionSuccess()
            } else {
                guard let completionFailure else { return }
                completionFailure()
            }
        }
    }
    
    func restorePurchases(vc: UIViewController, completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        let viewLoading = createLoadingPurchaseView(view: vc.view)
        vc.view.addSubview(viewLoading)

        Purchases.shared.restorePurchases { [self] purchaserInfo, _ in
            viewLoading.removeFromSuperview()
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                isUserPremium = true
                guard let completionSuccess else { return }
                completionSuccess()
            } else {
                guard let completionFailure else { return }
                completionFailure()
            }
        }
    }
    
    func verifySubscription(completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {
        Purchases.shared.getCustomerInfo { [self] purchaserInfo, _ in
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                isUserPremium = true
                UserDefaults.standard.setValue(isUserPremium, forKey: "isUserPremium")
                guard let completionSuccess else { return }
                completionSuccess()
            } else {
                isUserPremium = false
                UserDefaults.standard.setValue(isUserPremium, forKey: "isUserPremium")
                guard let completionFailure else { return }
                completionFailure()
            }
        }
    }
    
     func createLoadingPurchaseView(view: UIView) -> UIView {
        let view_loading = UIView()
        view_loading.frame = view.bounds
        view_loading.backgroundColor = .black
        view_loading.layer.opacity = 0.65

        let anim_loading = LottieAnimationView(name: loadingAnimation)
        anim_loading.frame = CGRect(x: 0.425 * UIScreen.main.bounds.width, y: 0.425 * UIScreen.main.bounds.height, width: 0.15 * UIScreen.main.bounds.width, height: 0.15 * UIScreen.main.bounds.height)
        anim_loading.center = view.center
        anim_loading.backgroundColor = .clear
        anim_loading.loopMode = .loop
        anim_loading.animationSpeed = 1
        anim_loading.backgroundBehavior = .pauseAndRestore
        view_loading.addSubview(anim_loading)
        anim_loading.play()
        return view_loading
    }
}
