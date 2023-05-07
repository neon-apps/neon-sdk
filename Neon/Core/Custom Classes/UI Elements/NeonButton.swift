//
//  File 2.swift
//  
//
//  Created by Tuna Öztürk on 3.04.2023.
//

import Foundation
import UIKit
import Localize_Swift

open class NeonButton : UIButton{
    
    public override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title?.localized(), for: state)
    }
    
}
