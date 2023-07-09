//
//  NeonPaywallManager.swift
//  neonApps-chatgpt
//
//  Created by Tuna Öztürk on 25.06.2023.
//
#if !os(xrOS)
import Foundation
import UIKit

@available(iOS 13.0, *)
public class AdaptyPaywallBuilder{
    
    static var shared = AdaptyPaywallBuilder()
    
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
  
    
    public static func configureAdaptyPaywall(paywallID : String, mainColor: UIColor, darkColor: UIColor, lightColor: UIColor, isDarkModeEnabled: Bool, weeklyProductID: String, lifetimeProductID: String, termsURL : String, privacyURL : String, feature1: NeonPaywallFeature, feature2: NeonPaywallFeature, feature3: NeonPaywallFeature, testemonial1: NeonTestemonial, testemonial2: NeonTestemonial, testemonial3: NeonTestemonial) {
        AdaptyPaywallBuilder.shared.paywallID = paywallID
        AdaptyPaywallBuilder.shared.mainColor = mainColor
        AdaptyPaywallBuilder.shared.darkColor = darkColor
        AdaptyPaywallBuilder.shared.lightColor = lightColor
        AdaptyPaywallBuilder.shared.isDarkModeEnabled = isDarkModeEnabled
        AdaptyPaywallBuilder.shared.weeklyProductID = weeklyProductID
        AdaptyPaywallBuilder.shared.lifetimeProductID = lifetimeProductID
        AdaptyPaywallBuilder.shared.termsURL = termsURL
        AdaptyPaywallBuilder.shared.privacyURL = privacyURL
        AdaptyPaywallBuilder.shared.feature1 = feature1
        AdaptyPaywallBuilder.shared.feature2 = feature2
        AdaptyPaywallBuilder.shared.feature3 = feature3
        AdaptyPaywallBuilder.shared.testemonial1 = testemonial1
        AdaptyPaywallBuilder.shared.testemonial2 = testemonial2
        AdaptyPaywallBuilder.shared.testemonial3 = testemonial3
    }
    
    var canDismiss = false
    
}
#endif
