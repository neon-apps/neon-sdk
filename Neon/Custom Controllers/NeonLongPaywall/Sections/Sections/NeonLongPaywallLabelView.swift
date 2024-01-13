//
//  NeonLongPaywallLabelView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallLabelView : BaseNeonLongPaywallSectionView{
    
    
    let label = UILabel()
    
    override func configureSection(type: NeonLongPaywallSectionType) {
        
        configureView()
        setConstraint()
        
        switch type {
        case .label(let text, let font, let color, let alignment, let horizontalPadding):
            label.text = text
            label.font = font
            label.textAlignment = alignment
            label.textColor = color ??  manager.constants.primaryTextColor
            label.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(horizontalPadding)
                make.top.equalToSuperview()
            }
            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }
    }
    
    func configureView(){
        label.numberOfLines = 0
        addSubview(label)
      
        label.sizeToFit()
    }
    
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(label.snp.bottom)
        }
    }
    
}
