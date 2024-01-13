//
//  BaseNeonLongPaywallSection.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import UIKit

@available(iOS 15.0, *)
open class BaseNeonLongPaywallSectionView: UIView {
    
    var manager = NeonLongPaywallManager()
    
    public init(type: NeonLongPaywallSectionType, manager : NeonLongPaywallManager) {
        super.init(frame: .zero)
        self.manager = manager
        configureSection(type : type)
    }
    public override func didMoveToSuperview() {
        
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    open func configureSection(type : NeonLongPaywallSectionType) {
        
    }
    
    func showContainer(){
        layer.cornerRadius = 10
        backgroundColor = manager.constants.containerColor
    }
}
