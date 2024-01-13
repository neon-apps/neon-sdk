//
//  NeonLongPaywallSpacingView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallSpacingView : BaseNeonLongPaywallSectionView{
    
    

    
    override func configureSection(type: NeonLongPaywallSectionType) {
        switch type {
        case .spacing(let height):
            snp.makeConstraints { make in
                make.height.equalTo(height)
            }
            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }
    }
    
  
    
 
    
}
