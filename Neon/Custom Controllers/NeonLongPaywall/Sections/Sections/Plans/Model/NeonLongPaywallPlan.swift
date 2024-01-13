//
//  NeonLongOnboardingPlan.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation


public class NeonLongPaywallPlan{
    
    public var productIdentifier : String
    public var tag : String?
    public var priceType = PriceType.default
    public var isDefaultSelected = Bool()
    public init(productIdentifier: String = String(), tag: String? = nil, priceType : PriceType = .default, isDefaultSelected : Bool = false) {
        self.productIdentifier = productIdentifier
        self.tag = tag
        self.priceType = priceType
        self.isDefaultSelected = isDefaultSelected
    }
    
    public enum PriceType{
        case `default`
        case perWeek
        case perMonth
    }
    public func copy() -> NeonLongPaywallPlan {
          return NeonLongPaywallPlan(productIdentifier: self.productIdentifier, tag: self.tag, priceType: self.priceType, isDefaultSelected: self.isDefaultSelected)
      }
      
    
    
}
