//
//  File.swift
//  
    //
//  Created by Tuna Öztürk on 3.12.2023.
//

import Foundation
import StoreKit

@available(iOS 11.2, *)
public class NeonPaywallManager{
    
   public static func isSubscription(product : SKProduct?) -> Bool{
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

