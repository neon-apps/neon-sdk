//
//  NeonReferralConstants.swift
//  PromotionCode
//
//  Created by cihangirincaz on 6.08.2024.
//

import Foundation
import UIKit

@available(iOS 16.0, *)
class NeonReferralConstants{
    static let shared = NeonReferralConstants()
    //MARK: remaining credit
    static var remainingCredit = 0
    //MARK: temp array
    var AllUser: [String] = []
    var newAllUsers: [String] = []
    //MARK: configure
    static var prizeAmount = Int()
    static var prizeTerminology = String()
    static var primaryTextColor = UIColor()
    static var mainColor = UIColor()
    static var secondaryTextColor = UIColor()
    static var backgroundColor = UIColor()
    static var containerColor = UIColor()
    static var buttonTextColor = UIColor()
}
