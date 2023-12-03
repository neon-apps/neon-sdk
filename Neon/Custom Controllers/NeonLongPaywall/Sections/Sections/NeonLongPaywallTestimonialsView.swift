//
//  NeonLongPaywallTestimonialView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 2.12.2023.
//

import Foundation
import UIKit
import NeonSDK
class NeonLongPaywallTestimonialsView : BaseNeonLongPaywallSectionView{
    
    
     let testimonialView = NeonTestimonialView()
    
    override func configureSection(type: NeonLongPaywallSectionType) {
        
        configureView()
        switch type {
        case .testimonials(let height, let items):
            
            addSubview(testimonialView)
            testimonialView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(height)
            }
            
 
            items.forEach { item in
                testimonialView.addTestimonial(title: item.title, testimonial: item.testimonial, author: item.author)
            }
            
            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }
        
        setConstraint()
    }
    
    private func configureView() {
        
       
        
        testimonialView.testimonialTextColor = NeonLongPaywallConstants.primaryTextColor
        testimonialView.testimonialbackgroundColor = NeonLongPaywallConstants.containerColor
        testimonialView.currentTestimonialPageTintColor = NeonLongPaywallConstants.mainColor
        testimonialView.testimonialPageTintColor = NeonLongPaywallConstants.secondaryTextColor
        testimonialView.testimonialbackgroundCornerRadious = Int(NeonLongPaywallConstants.cornerRadius)
        
        testimonialView.pageControlType = .V1
        
     }
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(testimonialView.snp.bottom)
        }
    }
    
}
