//
//  NeonLongPaywallPlanComparisonItem.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 3.12.2023.
//

import Foundation

public class NeonLongPaywallPlanComparisonItem: Equatable {
    public var feature: String
    public var availability: Availability

    public enum Availability {
        case locked
        case available
        case limited
    }

    public init(feature: String, availability: Availability) {
        self.feature = feature
        self.availability = availability
    }

    public static func == (lhs: NeonLongPaywallPlanComparisonItem, rhs: NeonLongPaywallPlanComparisonItem) -> Bool {
        return lhs.feature == rhs.feature &&
               lhs.availability == rhs.availability
    }
}
