//
//  manager.constants.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

public class NeonLongPaywallConstants{
    public var termsURL : String?
    public var privacyURL : String?
    public var provider = NeonLongPaywallProviderType.revenuecat
    public var isPaymentSheetActive = Bool()
    public var horizontalPadding = CGFloat()
    public var cornerRadius = CGFloat()
    public var containerBorderWidth = CGFloat()
    // Colors
    
    public var primaryTextColor = UIColor()
    public var secondaryTextColor = UIColor()
    public var selectedContainerColor = UIColor()
    public var containerColor = UIColor()
    public var selectedContainerBorderColor = UIColor()
    public var containerBorderColor = UIColor()
    public var mainColor = UIColor()
    public var backgroundColor = UIColor()
    public var ctaButtonTextColor = UIColor()
    
    // Variables
    
    public var selectedPlan = NeonLongPaywallPlan(){
        didSet{
            NeonNotificationCenter.post(id: "plan_selected", object: selectedPlan)
        }
    }
    public var allPlans = [NeonLongPaywallPlan]()
    
    public init(){
        
    }
}
