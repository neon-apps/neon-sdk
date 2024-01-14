//
//  NeonLongPaywallSection.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation


@available(iOS 15.0, *)
public class NeonLongPaywallSection{
    
    
    public var view : BaseNeonLongPaywallSectionView{
        switch type {
        case .spacing:
            return NeonLongPaywallSpacingView(type: type, manager: manager)
        case .label:
            return NeonLongPaywallLabelView(type: type, manager: manager)
        case .image:
            return NeonLongPaywallImageView(type: type, manager: manager)
        case .imageWithURL:
            return NeonLongPaywallImageView(type: type, manager: manager)
        case .features:
            return NeonLongPaywallFeaturesView(type: type, manager: manager)
        case .testimonialCard:
            return NeonLongPaywallTestimonialCardView(type: type, manager: manager)
        case .plans:
            return NeonLongPaywallPlansView(type: type, manager: manager)
        case .whatYouWillGet:
            return NeonLongPaywallWhatYouWillGetView(type: type, manager: manager)
        case .timeline:
            return NeonLongPaywallTimelineView(type: type, manager: manager)
        case .testimonials:
            return NeonLongPaywallTestimonialsView(type: type, manager: manager)
        case .faq:
            return NeonLongPaywallFAQView(type: type, manager: manager)
        case .planComparison:
            return NeonLongPaywallPlanComparisonView(type: type, manager: manager)
        case .trustBadge:
            return NeonLongPaywallTrustBadgeView(type: type, manager: manager)
        case .slide:
            return NeonLongPaywallSlideView(type: type, manager: manager)
        case .custom:
            return BaseNeonLongPaywallSectionView(type: type, manager: manager)
        }
        
    }
    
    public var type : NeonLongPaywallSectionType
    public var manager : NeonLongPaywallManager
    public init(type: NeonLongPaywallSectionType, manager : NeonLongPaywallManager) {
        self.type = type
        self.manager = manager
    }
    
    public func copy(with manager : NeonLongPaywallManager) -> NeonLongPaywallSection {
        let copiedSection = NeonLongPaywallSection(type: self.type.copy(), manager: manager)
         return copiedSection
     }
}

