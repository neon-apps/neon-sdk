//
//  NeonLongPaywallPlanManager.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 23.11.2023.
//

import Foundation
import NeonSDK
import UIKit
import StoreKit


public enum NeonLongPaywallPlanViewType{
    case horizontal
    case vertical
}
protocol NeonLongPaywallPlanViewDelegate{
    func planSelected()
}

@available(iOS 15.0, *)
class NeonLongPaywallPlanManager {
  
    var allPlans = [NeonLongPaywallPlan]()
    var plan : NeonLongPaywallPlan?
        
    func fetchProduct(for plan : NeonLongPaywallPlan) -> SKProduct?{
        if let adaptyPackage = AdaptyManager.getPackage(id: plan.productIdentifier){
            return adaptyPackage.skProduct
        }else if let revenueCatPackage = RevenueCatManager.getPackage(id: plan.productIdentifier){
            return revenueCatPackage.storeProduct.sk1Product
        }else{
            return nil
        }
    }
    
     func configurePriceWithProduct(product : SKProduct, durationLabel : UILabel,  unitCostLabel : UILabel, plan : NeonLongPaywallPlan, allPlans : [NeonLongPaywallPlan]){
        
        self.plan = plan
        self.allPlans = allPlans
        
        switch plan.priceType{
        case .default:
            showDefaultPriceFor(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
            break
        case .perWeek:
            showWeeklyPriceFor(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
            break
        case .perMonth:
            showMonthlyPriceFor(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
            break
        }
    }
    
    func getDefaultPrice(product : SKProduct) -> String{
        let price = product.price
        let currencyCode = product.priceLocale.currencyCode
        let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
        let formattedPrice = formatPrice(price: price)
        return "\(currencySymbol)\(formattedPrice)"
    }
    
    func showDefaultPriceFor(product : SKProduct, durationLabel : UILabel,  unitCostLabel : UILabel){
        if let numberOfUnits = product.subscriptionPeriod?.numberOfUnits,
           let unit = product.subscriptionPeriod?.unit{
            let price = product.price
            let (unitString, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
            durationLabel.text = durationLabelText
            let currencyCode = product.priceLocale.currencyCode
            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
            let formattedPrice = formatPrice(price: price)
            if let unitString{
                unitCostLabel.text = "\(currencySymbol)\(formattedPrice) / \(unitString)"
            }else{
                unitCostLabel.text = "\(currencySymbol)\(formattedPrice)"
            }
            
        }else{
            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
        }
    }
    
    
    func showWeeklyPriceFor(product : SKProduct, durationLabel : UILabel,  unitCostLabel : UILabel){
        if let numberOfUnits = product.subscriptionPeriod?.numberOfUnits,
           let unit = product.subscriptionPeriod?.unit{
            let price = product.price
            let weekCount = calculateWeekCount(unit: unit, numberOfUnits: numberOfUnits)
            let (_, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
            durationLabel.text = durationLabelText
            let currencyCode = product.priceLocale.currencyCode
            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
            let pricePerWeek = calculatePricePerUnit(numberOfUnits: weekCount, price: price)
            unitCostLabel.text = "\(currencySymbol)\(pricePerWeek) / week"
        }else{
            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
        }
    }
    
    func showMonthlyPriceFor(product : SKProduct, durationLabel : UILabel,  unitCostLabel : UILabel){
        if let numberOfUnits = product.subscriptionPeriod?.numberOfUnits,
           let unit = product.subscriptionPeriod?.unit{
            let price = product.price
            let monthCount = calculateMonthCount(unit: unit, numberOfUnits: numberOfUnits)
            let (_, durationLabelText) = getUnitString(unit: unit, numberOfUnits: numberOfUnits)
            durationLabel.text = durationLabelText
            let currencyCode = product.priceLocale.currencyCode
            let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
            let pricePerMonth = calculatePricePerUnit(numberOfUnits: monthCount, price: price)
            unitCostLabel.text = "\(currencySymbol)\(pricePerMonth) / month"
        }else{
            showLifetimePrice(product: product, durationLabel: durationLabel, unitCostLabel: unitCostLabel)
        }
    }
    
    
    func getUnitString(unit : SKProduct.PeriodUnit, numberOfUnits : Int) -> (String?, String?){
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
    
    
    func getTrialDuration(product : SKProduct) -> Int?{
        
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
    func showLifetimePrice(product : SKProduct, durationLabel : UILabel,  unitCostLabel : UILabel){
        
        let price = product.price
        let currencyCode = product.priceLocale.currencyCode
        let currencySymbol = NeonCurrencyManager.getCurrencySymbol(for: currencyCode ?? "USD") ?? "$"
        let formattedPrice = formatPrice(price: price)
        unitCostLabel.text = "\(currencySymbol)\(price)"
        durationLabel.text = "Lifetime"
        
    }
    
    func calculateWeekCount(unit : SKProduct.PeriodUnit, numberOfUnits : Int) -> Int{
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
    
    func calculateMonthCount(unit : SKProduct.PeriodUnit, numberOfUnits : Int) -> Int{
        switch unit {
        case .day:
            fatalError("You can't show monthly price for a weekly subscription.")
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
    
    func calculatePricePerDay(product : SKProduct) -> Double?{
        
        if let numberOfUnits = product.subscriptionPeriod?.numberOfUnits,
           let unit = product.subscriptionPeriod?.unit{
            
            let price = product.price
            
            var dayCount = Int()
            
            switch unit {
            case .day:
                dayCount = numberOfUnits
            case .week:
                dayCount = numberOfUnits * 7
            case .month:
                dayCount = numberOfUnits * 30
            case .year:
                dayCount = numberOfUnits * 365
            default :
                return nil
            }
            
            return Double(truncating: price) / Double(dayCount)
            
            
        }else{
            return nil
        }
        
        
        
        
    }
    
    func calculatePricePerUnit(numberOfUnits : Int, price : NSDecimalNumber) -> String{
        return String(format: "%.2f", Double(truncating: price) / Double(numberOfUnits))
    }
    
    func formatPrice(price : NSDecimalNumber) -> String{
        return String(format: "%.2f", Double(truncating: price))
    }
    
    func getMostExpensivePlanPricePerDay() -> Double{
        var mostExpensivePlanPricePerDay = Double()
        
        for plan in allPlans {
            if let product = fetchProduct(for: plan), let pricePerDayForPlan =  calculatePricePerDay(product: product) {
                if pricePerDayForPlan > mostExpensivePlanPricePerDay{
                    mostExpensivePlanPricePerDay = pricePerDayForPlan
                }
            }
        }
        
        return mostExpensivePlanPricePerDay
    }
    
    func calculateSaveRatio(currentPlanPricePerDay: Double, mostExpensivePlanPricePerDay: Double) -> String {
        
        guard mostExpensivePlanPricePerDay != 0 else {
            return ""
        }
        
        let savingsRatio = (1 - currentPlanPricePerDay / mostExpensivePlanPricePerDay) * 100
        
        let roundedSavings = Int(round(savingsRatio))
        
        if roundedSavings == 0{
            return ""
        }
        return "Save \(roundedSavings)%"
    }
    
    
    func calculateTagLabel(tagLabel : UILabel){
        
        guard let plan else { return }
        
        if let currentProduct = fetchProduct(for: plan){
            if let freeTrialDuration = getTrialDuration(product: currentProduct){
                tagLabel.text = plan.tag?.replacingOccurrences(of: "free_trial_duration", with: "\(freeTrialDuration)") ?? "\(freeTrialDuration)-DAY FREE"
            }else{
                tagLabel.text = plan.tag ?? " "
            }
        }
        
        
    }
    
    func calculateSaveLabel(saveLabel : UILabel){
        
        guard let plan else { return }
        
        if let currentProduct = fetchProduct(for: plan),  let currentPlanPricePerDay = calculatePricePerDay(product: currentProduct){
            let mostExpensivePlanPricePerDay = getMostExpensivePlanPricePerDay()
            if currentPlanPricePerDay != mostExpensivePlanPricePerDay{
                saveLabel.text = calculateSaveRatio(currentPlanPricePerDay: currentPlanPricePerDay, mostExpensivePlanPricePerDay: mostExpensivePlanPricePerDay)
            }
        }
        
    }
    
    func isDefaultPlan() -> Bool{
        
        guard let plan else { return false }
        let defaultSelectedPlanCount =  allPlans.filter({$0.isDefaultSelected}).count
        
        if defaultSelectedPlanCount == 0{
            fatalError("You have to select one plan as a default selected one. You should add isDefaultSelected parameter as true while initalization of the plan.")
        }else if defaultSelectedPlanCount > 1{
            fatalError("You can't make more than 1 plan default selected. Please make sure that you only add isDefaultSelected parameter as true for 1 plan")
        }
        
        if plan.isDefaultSelected{
           return true
        }
        
        return false
    }
}
