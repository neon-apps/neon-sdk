//
//  NeonLongPaywallSlideView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 3.12.2023.
//

import Foundation
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallSlideView : BaseNeonLongPaywallSectionView{
    
    
     let slidesView = NeonSlideView()
    
    override func configureSection(type: NeonLongPaywallSectionType) {
        
        configureView()
        switch type {
        case .slide(let height,let showBeforeAfterBadges, let items):
            
            addSubview(slidesView)
            slidesView.showBeforeAfterBadges = showBeforeAfterBadges
            slidesView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(height)
            }
            
 
            items.forEach { item in
                if let firstImage = item.firstImage, let secondImage = item.secondImage{
                    slidesView.addSlide(firstImage: firstImage, secondImage: secondImage, title: item.title, subtitle: item.subtitle)
                }else if let firstImageURL = item.firstImageURL, let secondImageURL = item.secondImageURL{
                    slidesView.addSlide(firstImageURL: firstImageURL, secondImageURL: secondImageURL, title: item.title, subtitle: item.subtitle)
                }
              
            }
            
            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }
        
        setConstraint()
    }
    
    private func configureView() {
        
       
        
        slidesView.textColor = manager.constants.primaryTextColor
        slidesView.beforeAfterBadgesTextColor = manager.constants.ctaButtonTextColor
        slidesView.slideBackgroundColor = manager.constants.containerColor
        slidesView.mainColor = manager.constants.mainColor
        slidesView.pageTintColor = manager.constants.secondaryTextColor
        slidesView.slideBackgroundCornerRadious = Int(manager.constants.cornerRadius)
        slidesView.pageControlType = .V1
        
     }
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(slidesView.snp.bottom)
        }
    }
    
}
