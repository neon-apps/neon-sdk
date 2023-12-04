//
//  NeonLongPaywallConstants.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

public class NeonLongPaywallConstants{
    static var termsURL : String?
    static var privacyURL : String?
    public static var provider = NeonLongPaywallProviderType.revenuecat
    static var isPaymentSheetActive = Bool()
    static var horizontalPadding = CGFloat()
    static var cornerRadius = CGFloat()
    static var containerBorderWidth = CGFloat()
    // Colors
    
    static var primaryTextColor = UIColor()
    static var secondaryTextColor = UIColor()
    static var selectedContainerColor = UIColor()
    static var containerColor = UIColor()
    static var selectedContainerBorderColor = UIColor()
    static var containerBorderColor = UIColor()
    static var mainColor = UIColor()
    static var backgroundColor = UIColor()
    static var ctaButtonTextColor = UIColor()
    
    // Variables
    
    static var selectedPlan = NeonLongPaywallPlan(){
        didSet{
            NeonNotificationCenter.post(id: "plan_selected", object: selectedPlan)
        }
    }
    static var allPlans = [NeonLongPaywallPlan]()
}
