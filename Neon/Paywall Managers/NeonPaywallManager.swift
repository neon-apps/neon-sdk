//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 3.12.2023.
//

import Foundation
import StoreKit

class NeonPaywallManager{
    
    static func isSubscription(product : SKProduct?) -> Bool{
        if let product{
            if let _ = product.subscriptionPeriod?.numberOfUnits,
               let _ = product.subscriptionPeriod?.unit{
                return true
            }else{
                return false
            }
        }
        return false
    }
    
}
