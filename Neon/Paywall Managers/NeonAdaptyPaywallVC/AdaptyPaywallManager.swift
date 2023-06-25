//
//  NeonPaywallManager.swift
//  neonApps-chatgpt
//
//  Created by Tuna Öztürk on 25.06.2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class AdaptyPaywallManager{
    
    static var shared = AdaptyPaywallManager()
    
    var bestSellerLabelText = AdaptyManager.getRemoteConfigValue(id: "bestSellerLabelText") as? String ?? "Best Seller"
    var ctaButtonTextWhenLifetimeSelected = AdaptyManager.getRemoteConfigValue(id: "ctaButtonTextWhenLifetimeSelected") as? String ?? "Unlock All Premium Features"
    var ctaButtonTextWhenWeeklySelected = AdaptyManager.getRemoteConfigValue(id: "ctaButtonTextWhenWeeklySelected") as? String ?? "Start my 3-day free trial"
    var titleLabelTextWhenWeeklySelected = AdaptyManager.getRemoteConfigValue(id: "titleLabelTextWhenWeeklySelected") as? String ?? "START YOUR 3 DAYS FREE TRIAL"
    var titleLabelTextWhenLifetimeSelected = AdaptyManager.getRemoteConfigValue(id: "titleLabelTextWhenLifetimeSelected") as? String ?? "UNLOCK UNLIMITED ACCESS"
    var closeButtonAlpha = AdaptyManager.getRemoteConfigValue(id: "closeButtonAlpha") as? Double ?? 0.5
    var closeButtonSize = AdaptyManager.getRemoteConfigValue(id: "closeButtonSize") as? Double ?? 20
    var closeButtonAppearanceDuration = AdaptyManager.getRemoteConfigValue(id: "closeButtonAppearanceDuration") as? Double ?? 0
    var ctaButtonBouncingDuration = AdaptyManager.getRemoteConfigValue(id: "ctaButtonBouncingDuration") as? Double ?? 0.8
    var ctaButtonBouncedScale = AdaptyManager.getRemoteConfigValue(id: "ctaButtonBouncedScale") as? Double ?? 1.15
    
    
    var paywallID = String()
    
    var mainColor = UIColor.blue
    var darkColor = UIColor.red
    var lightColor = UIColor.green
    
    var isDarkModeEnabled = true
    
    var weeklyProductID = ""
    var lifetimeProductID = ""
    
    var homeVC = UIViewController()
    
    var termsURL = String()
    var privacyURL = String()
    
    var feature1 = NeonPaywallFeature()
    var feature2 = NeonPaywallFeature()
    var feature3 = NeonPaywallFeature()

    var testemonial1 = NeonTestemonial()
    var testemonial2 = NeonTestemonial()
    var testemonial3 = NeonTestemonial()
  
    
    static func configureAdaptyPaywall(paywallID : String, mainColor: UIColor, darkColor: UIColor, lightColor: UIColor, isDarkModeEnabled: Bool, weeklyProductID: String, lifetimeProductID: String, homeVC: UIViewController, termsURL : String, privacyURL : String, feature1: NeonPaywallFeature, feature2: NeonPaywallFeature, feature3: NeonPaywallFeature, testemonial1: NeonTestemonial, testemonial2: NeonTestemonial, testemonial3: NeonTestemonial) {
        AdaptyPaywallManager.shared.mainColor = mainColor
        AdaptyPaywallManager.shared.darkColor = darkColor
        AdaptyPaywallManager.shared.lightColor = lightColor
        AdaptyPaywallManager.shared.isDarkModeEnabled = isDarkModeEnabled
        AdaptyPaywallManager.shared.weeklyProductID = weeklyProductID
        AdaptyPaywallManager.shared.lifetimeProductID = lifetimeProductID
        AdaptyPaywallManager.shared.homeVC = homeVC
        AdaptyPaywallManager.shared.termsURL = termsURL
        AdaptyPaywallManager.shared.privacyURL = privacyURL
        AdaptyPaywallManager.shared.feature1 = feature1
        AdaptyPaywallManager.shared.feature2 = feature2
        AdaptyPaywallManager.shared.feature3 = feature3
        AdaptyPaywallManager.shared.testemonial1 = testemonial1
        AdaptyPaywallManager.shared.testemonial2 = testemonial2
        AdaptyPaywallManager.shared.testemonial3 = testemonial3
    }
    
    var canDismiss = false
    
    static func presentAdaptyPaywall(controller : UIViewController, canDismiss : Bool = true){
        AdaptyPaywallManager.shared.canDismiss = canDismiss
        controller.present(destinationVC: NeonAdaptyPaywallVC(), slideDirection: .up)
    }
}
