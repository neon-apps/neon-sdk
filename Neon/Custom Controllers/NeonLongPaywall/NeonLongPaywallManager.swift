//
//  NeonLongPaywallManager.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit


public protocol PaywallerDelegate {
    func purchased(from controller : UIViewController, identifier : String)
    func restored(from controller : UIViewController)
    func dismissed(from controller : UIViewController)
    
}
@available(iOS 15.0, *)
public class NeonLongPaywallManager{
    
    public var paywall : NeonLongPaywallController?
    public var sections = [NeonLongPaywallSection]()
    public var delegate : PaywallerDelegate?
    public var constants = NeonLongPaywallConstants()
    
    public init(){
        
    }
    public func configure(
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
        constants.provider = provider
        constants.isPaymentSheetActive = isPaymentSheetActive
        constants.horizontalPadding = horizontalPadding
        constants.cornerRadius = cornerRadius
        constants.containerBorderWidth = containerBorderWidth
        constants.primaryTextColor = primaryTextColor
        constants.secondaryTextColor = secondaryTextColor
        constants.containerColor = containerColor
        constants.selectedContainerColor = selectedContainerColor
        constants.containerBorderColor = containerBorderColor
        constants.selectedContainerBorderColor = selectedContainerBorderColor
        constants.mainColor = mainColor
        constants.backgroundColor = backgroundColor
        constants.ctaButtonTextColor = ctaButtonTextColor
        constants.termsURL = termsURL
        constants.privacyURL = privacyURL
          paywall = NeonLongPaywallController()
      }
    
    public func present(from controller : UIViewController){
        if paywall != nil{
            controller.present(destinationVC: paywall!, slideDirection: .up)
        }else{
           fatalError("You should configure paywall with NeonLongPaywallManager.configure method before present it.")
        }
      
    }
    public func getPaywall() -> UIViewController{
        if paywall != nil{
            return paywall!
        }else{
           fatalError("You should configure paywall with NeonLongPaywallManager.configure method before present it.")
        }
      
    }
    
    public func addSection(type : NeonLongPaywallSectionType){
        if paywall != nil{
            sections.append(NeonLongPaywallSection(type: type, manager: self))
        }else{
           fatalError("You should configure paywall with NeonLongPaywallManager.configure method before adding sections.")
        }
       
    }
    
    public func copy() -> NeonLongPaywallManager {
            let copiedManager = NeonLongPaywallManager()

            copiedManager.paywall = self.paywall
            copiedManager.delegate = self.delegate
            copiedManager.constants = self.constants.copy()
            for section in self.sections {
                copiedManager.sections.append(section.copy(with: copiedManager))
            }

            return copiedManager
        }
    
}
