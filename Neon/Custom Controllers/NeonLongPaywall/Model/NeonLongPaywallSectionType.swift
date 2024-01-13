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
    case imageWithURL(height : CGFloat, url : String, cornerRadious : CGFloat, horizontalPadding :CGFloat, contentMode : UIView.ContentMode)
    case features(items : [NeonPaywallFeature], overrideTextColor : UIColor? = nil,  font : UIFont? = nil, iconTintColor : UIColor? = nil, offset : CGFloat? = nil)
    case testimonialCard(title : String, subtitle : String, author : String? = nil, overrideImage : UIImage? = nil,  overrideImageWithURL : String? = nil)
    case plans(type : NeonLongPaywallPlanViewType, items : [NeonLongPaywallPlan])
    case whatYouWillGet(title : String, hasContainer : Bool, items : [NeonLongPaywallWhatYouWillGetItem])
    case timeline(hasContainer : Bool, items : [NeonLongPaywallTimelineItem] )
    case testimonials(height : CGFloat = 220, items : [NeonTestimonial] )
    case faq(title : String, items : [NeonLongPaywallFAQItem])
    case planComparison(items : [NeonLongPaywallPlanComparisonItem] )
    case trustBadge(type : NeonLongPaywallTrustBadgeType )
    case slide(height : CGFloat = 400, showBeforeAfterBadges : Bool, items : [NeonSlideItem] )
    case custom(view : UIView)
    
    public func copy() -> NeonLongPaywallSectionType {
         switch self {
         case .spacing(let height):
             return .spacing(height: height)
         case .label(let text, let font, let overrideTextColor, let alignment, let horizontalPadding):
             return .label(text: text, font: font, overrideTextColor: overrideTextColor, alignment: alignment, horizontalPadding: horizontalPadding)
         case .image(let height, let image, let cornerRadius, let horizontalPadding, let contentMode):
             return .image(height: height, image: image, cornerRadious: cornerRadius, horizontalPadding: horizontalPadding, contentMode: contentMode)
         case .imageWithURL(let height, let url, let cornerRadius, let horizontalPadding, let contentMode):
             return .imageWithURL(height: height, url: url, cornerRadious: cornerRadius, horizontalPadding: horizontalPadding, contentMode: contentMode)
         case .features(let items, let overrideTextColor, let font, let iconTintColor, let offset):
             return .features(items: items, overrideTextColor: overrideTextColor, font: font, iconTintColor: iconTintColor, offset: offset)
         case .testimonialCard(let title, let subtitle, let author, let overrideImage, let overrideImageWithURL):
             return .testimonialCard(title: title, subtitle: subtitle, author: author, overrideImage: overrideImage, overrideImageWithURL: overrideImageWithURL)
         case .plans(let type, let items):
             return .plans(type: type, items: items)
         case .whatYouWillGet(let title, let hasContainer, let items):
             return .whatYouWillGet(title: title, hasContainer: hasContainer, items: items)
         case .timeline(let hasContainer, let items):
             return .timeline(hasContainer: hasContainer, items: items)
         case .testimonials(let height, let items):
             return .testimonials(height: height, items: items)
         case .faq(let title, let items):
             return .faq(title: title, items: items)
         case .planComparison(let items):
             return .planComparison(items: items)
         case .trustBadge(let type):
             return .trustBadge(type: type)
         case .slide(let height, let showBeforeAfterBadges, let items):
             return .slide(height: height, showBeforeAfterBadges: showBeforeAfterBadges, items: items)
         case .custom(let view):
             // Handle the custom case by creating a copy of the UIView or whatever type it represents.
             if let viewCopyable = view.copy() as? UIView {
                 return .custom(view: viewCopyable)
             } else {
                 // Return the original custom case if it cannot be copied.
                 return .custom(view: view)
             }
         }
     }
}
