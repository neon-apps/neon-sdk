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
    
    public static func getDefaultPrice(product : SKProduct?) -> String{
        guard let product else {  return "..." }
        let price = product.price
        let currencyCode = product.priceLocale.currencyCode
        let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
        let formattedPrice = formatPrice(price: price)
        return "\(currencySymbol)\(formattedPrice)"
    }
    
    
    
    public static func getWeeklyPriceFor(product : SKProduct?) -> String{
        guard let product else {  return "..." }
        if let numberOfUnits = product.subscriptionPeriod?.numberOfUnits,
           let unit = product.subscriptionPeriod?.unit{
            let price = product.price
            let weekCount = calculateWeekCount(unit: unit, numberOfUnits: numberOfUnits)
            let (_, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
            let currencyCode = product.priceLocale.currencyCode
            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
            let pricePerWeek = calculatePricePerUnit(numberOfUnits: weekCount, price: price)
            return "\(currencySymbol)\(pricePerWeek)"
        }else{
            return "..."
        }
    }
    
    public static func getMonthlyPriceFor(product : SKProduct?) -> String{
        guard let product else {  return "..." }
        if let numberOfUnits = product.subscriptionPeriod?.numberOfUnits,
           let unit = product.subscriptionPeriod?.unit{
            let price = product.price
            let monthCount = calculateMonthCount(unit: unit, numberOfUnits: numberOfUnits)
            let (_, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
            let currencyCode = product.priceLocale.currencyCode
            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
            let pricePerMonth = calculatePricePerUnit(numberOfUnits: monthCount, price: price)
            return "\(currencySymbol)\(pricePerMonth)"
        }else{
            return "..."
        }
    }
    
    
    private static func getUnitString(unit : SKProduct.PeriodUnit, numberOfUnits : Int) -> (String?, String?){
        switch unit {
        case .day:
            if numberOfUnits == 7{
                return ("week", "Weekly")
            }
        case .week:
            if numberOfUnits == 1{
                return ("week", "Weekly")
            }
        case .month:
            if numberOfUnits == 1{
                return ("month", "Monthly")
            }
            if numberOfUnits == 2{
                return (nil, "2 Months")
            }
            if numberOfUnits == 3{
                return (nil, "3 Months")
            }
            if numberOfUnits == 6{
                return (nil, "6 Months")
            }
            if numberOfUnits == 12{
                return ("year", "Annual")
            }
        case .year:
            if numberOfUnits == 1{
                return ("year", "Annual")
            }
        default :
            return (nil, nil)
        }
        
        return (nil, nil)
    }
    
    
    public static func getTrialDuration(product : SKProduct) -> Int?{
        
        if let numberOfUnits = product.introductoryPrice?.subscriptionPeriod.numberOfUnits,
           let unit = product.introductoryPrice?.subscriptionPeriod.unit{
            
            switch unit {
            case .day:
                return numberOfUnits
            case .week:
                return numberOfUnits * 7
            case .month:
                return numberOfUnits * 30
            case .year:
                return numberOfUnits * 365
            default :
                return nil
            }
            
        }else{
            return nil
        }
        
    }
    public static func getIntroductoryPeriod(product : SKProduct, completion : (_ duration: Int?, _ price: String?) -> ()){
        
        if let numberOfUnits = product.introductoryPrice?.subscriptionPeriod.numberOfUnits,
           let unit = product.introductoryPrice?.subscriptionPeriod.unit{
            
            var introductoryPrice : String?
            
            if let price = product.introductoryPrice?.price{
                if price != 0.0{
                    let currencyCode = product.priceLocale.currencyCode
                    let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
                    introductoryPrice = "\(currencySymbol)\(formatPrice(price: price))"
                }
            }
  
            switch unit {
            case .day:
                completion(numberOfUnits, introductoryPrice)
            case .week:
                completion (numberOfUnits * 7, introductoryPrice)
            case .month:
                completion (numberOfUnits * 30, introductoryPrice)
            case .year:
                completion (numberOfUnits * 365, introductoryPrice)
            default :
                completion (nil,nil)
            }
            
        }else{
            completion (nil,nil)
        }
        
    }
    
    public static func hasIntorductoryPeriod(product : SKProduct?) -> Bool{
        guard let product else { return false }
        var hasIntorductoryPeriod = false
        getIntroductoryPeriod(product: product) { duration, price in
            if let duration, duration != 0{
                hasIntorductoryPeriod = true
            }
        }
        return hasIntorductoryPeriod
    }
    
    public static func trackPurchase(product : SKProduct?){
        guard let product else { return }
        getIntroductoryPeriod(product: product) { duration, price in
            if let duration, duration != 0{
                NeonAppTracking.trackTrialStart()
            }else{
                NeonAppTracking.trackDirectSubscription()
            }
        }
    }
 
    func formatPrice(price : NSDecimalNumber) -> String{
        return String(format: "%.2f", Double(truncating: price))
    }
    
    private static func calculateWeekCount(unit : SKProduct.PeriodUnit, numberOfUnits : Int) -> Int{
        switch unit {
        case .day:
            return numberOfUnits / 7
        case .week:
            return numberOfUnits
        case .month:
            return numberOfUnits * 4
        case .year:
            return numberOfUnits * 52
        default :
            return 0
        }
    }
    
    private static func calculateMonthCount(unit : SKProduct.PeriodUnit, numberOfUnits : Int) -> Int{
        switch unit {
        case .day:
            return 0
        case .week:
            return Int(numberOfUnits / 4)
        case .month:
            return numberOfUnits
        case .year:
            return numberOfUnits * 12
        default :
            return 0
        }
    }
    
   
    
    private static func calculatePricePerUnit(numberOfUnits : Int, price : NSDecimalNumber) -> String{
        return String(format: "%.2f", Double(truncating: price) / Double(numberOfUnits))
    }
    
    private static func formatPrice(price : NSDecimalNumber) -> String{
        return String(format: "%.2f", Double(truncating: price))
    }
    
}

