//
//  BaseNeonLongPaywallSection.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import UIKit
import NeonSDK
public class BaseNeonLongPaywallSectionView: UIView {
    

    public init(type: NeonLongPaywallSectionType) {
        super.init(frame: .zero)
        configureSection(type : type)
    }
    public override func didMoveToSuperview() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func configureSection(type : NeonLongPaywallSectionType) {
        
    }
    
    func showContainer(){
        layer.cornerRadius = 10
        backgroundColor = NeonLongPaywallConstants.containerColor
    }
}
