//
//  NeonLongPaywallSectionType.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

public enum NeonLongPaywallSectionType{
    case spacing(height : CGFloat)
    case label(text : String, font : UIFont, overrideTextColor : UIColor? = nil, alignment : NSTextAlignment, horizontalPadding :CGFloat)
    case image(height : CGFloat, image : UIImage, cornerRadious : CGFloat, horizontalPadding :CGFloat, contentMode : UIView.ContentMode)
    case features(items : [NeonPaywallFeature], overrideTextColor : UIColor? = nil,  font : UIFont? = nil, iconTintColor : UIColor? = nil, offset : CGFloat? = nil)
    case testimonialCard(title : String, subtitle : String, author : String? = nil, overrideImage : UIImage? = nil)
    case plans(type : NeonLongPaywallPlanViewType, items : [NeonLongPaywallPlan])
    case whatYouWillGet(title : String, hasContainer : Bool, items : [NeonLongPaywallWhatYouWillGetItem])
    case timeline(hasContainer : Bool, items : [NeonLongPaywallTimelineItem] )
    case testimonials(height : CGFloat = 220, items : [NeonTestimonial] )
    case faq(title : String, hasContainer : Bool, items : [NeonLongPaywallFAQItem] )
    case planComparison(items : [NeonLongPaywallPlanComparisonItem] )
    case trustBadge(type : NeonLongPaywallTrustBadgeType )
    case slide(height : CGFloat = 400, showBeforeAfterBadges : Bool, items : [NeonSlideItem] )
    case custom(view : BaseNeonLongPaywallSectionView)
}
