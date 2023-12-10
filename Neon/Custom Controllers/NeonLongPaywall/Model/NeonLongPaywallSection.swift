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
            return NeonLongPaywallSpacingView(type: type)
        case .label:
            return NeonLongPaywallLabelView(type: type)
        case .image:
            return NeonLongPaywallImageView(type: type)
        case .imageWithURL:
            return NeonLongPaywallImageView(type: type)
        case .features:
            return NeonLongPaywallFeaturesView(type: type)
        case .testimonialCard:
            return NeonLongPaywallTestimonialCardView(type: type)
        case .plans:
            return NeonLongPaywallPlansView(type: type)
        case .whatYouWillGet:
            return NeonLongPaywallWhatYouWillGetView(type: type)
        case .timeline:
            return NeonLongPaywallTimelineView(type: type)
        case .testimonials:
            return NeonLongPaywallTestimonialsView(type: type)
        case .faq:
            return NeonLongPaywallFAQView(type: type)
        case .planComparison:
            return NeonLongPaywallPlanComparisonView(type: type)
        case .trustBadge:
            return NeonLongPaywallTrustBadgeView(type: type)
        case .slide:
            return NeonLongPaywallSlideView(type: type)
        case .custom:
            return BaseNeonLongPaywallSectionView(type: type)
        }
        
    }
    
    public var type : NeonLongPaywallSectionType
    
    public init(type: NeonLongPaywallSectionType) {
        self.type = type
    }
    
}

