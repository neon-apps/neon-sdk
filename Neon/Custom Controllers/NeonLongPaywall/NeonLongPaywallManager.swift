//
//  NeonLongPaywallManager.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit


protocol NeonLongPaywallDelegate {
    func purchased(from controller : UIViewController, identifier : String)
    func restored(from controller : UIViewController)
    func dismissed(from controller : UIViewController)
    
}
public class NeonLongPaywallManager{
    
    static var paywall : NeonLongPaywallController?
    static var sections = [NeonLongPaywallSection]()
    static var delegate : NeonLongPaywallDelegate?
    
    public static func configure(
        provider : NeonLongPaywallProviderType,
        isPaymentSheetActive : Bool,
        horizontalPadding: CGFloat,
        cornerRadius: CGFloat,
        containerBorderWidth : CGFloat,
        mainColor: UIColor,
        backgroundColor: UIColor,
        primaryTextColor: UIColor,
        secondaryTextColor: UIColor,
        containerColor: UIColor,
        selectedContainerColor: UIColor,
        containerBorderColor: UIColor,
        selectedContainerBorderColor: UIColor,
        ctaButtonTextColor: UIColor,
        termsURL : String? = nil,
        privacyURL : String? = nil
        
    ) {
        NeonLongPaywallConstants.provider = provider
        NeonLongPaywallConstants.isPaymentSheetActive = isPaymentSheetActive
        NeonLongPaywallConstants.horizontalPadding = horizontalPadding
        NeonLongPaywallConstants.cornerRadius = cornerRadius
        NeonLongPaywallConstants.containerBorderWidth = containerBorderWidth
        NeonLongPaywallConstants.primaryTextColor = primaryTextColor
        NeonLongPaywallConstants.secondaryTextColor = secondaryTextColor
        NeonLongPaywallConstants.containerColor = containerColor
        NeonLongPaywallConstants.selectedContainerColor = selectedContainerColor
        NeonLongPaywallConstants.containerBorderColor = containerBorderColor
        NeonLongPaywallConstants.selectedContainerBorderColor = selectedContainerBorderColor
        NeonLongPaywallConstants.mainColor = mainColor
        NeonLongPaywallConstants.backgroundColor = backgroundColor
        NeonLongPaywallConstants.ctaButtonTextColor = ctaButtonTextColor
        NeonLongPaywallConstants.termsURL = termsURL
        NeonLongPaywallConstants.privacyURL = privacyURL
          paywall = NeonLongPaywallController()
      }
    public static func present(from controller : UIViewController){
        if paywall != nil{
            controller.present(destinationVC: paywall!, slideDirection: .up)
        }else{
           fatalError("You should configure paywall with NeonLongPaywallManager.configure method before present it.")
        }
      
    }
    public static func getPaywall() -> UIViewController{
        if paywall != nil{
            return paywall!
        }else{
           fatalError("You should configure paywall with NeonLongPaywallManager.configure method before present it.")
        }
      
    }
    
    public static func addSection(type : NeonLongPaywallSectionType){
        if paywall != nil{
            NeonLongPaywallManager.sections.append(NeonLongPaywallSection(type: type))
        }else{
           fatalError("You should configure paywall with NeonLongPaywallManager.configure method before adding sections.")
        }
       
    }
    
}
