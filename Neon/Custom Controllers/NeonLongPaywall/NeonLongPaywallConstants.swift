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
    public static var termsURL : String?
    public static var privacyURL : String?
    public static var provider = NeonLongPaywallProviderType.revenuecat
    public static var isPaymentSheetActive = Bool()
    public static var horizontalPadding = CGFloat()
    public static var cornerRadius = CGFloat()
    public static var containerBorderWidth = CGFloat()
    // Colors
    
    public static var primaryTextColor = UIColor()
    public static var secondaryTextColor = UIColor()
    public static var selectedContainerColor = UIColor()
    public static var containerColor = UIColor()
    public static var selectedContainerBorderColor = UIColor()
    public static var containerBorderColor = UIColor()
    public static var mainColor = UIColor()
    public static var backgroundColor = UIColor()
    public static var ctaButtonTextColor = UIColor()
    
    // Variables
    
    public static var selectedPlan = NeonLongPaywallPlan(){
        didSet{
            NeonNotificationCenter.post(id: "plan_selected", object: selectedPlan)
        }
    }
    public static var allPlans = [NeonLongPaywallPlan]()
}
