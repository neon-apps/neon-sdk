//
//  NeonPaywallFeature.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 8.06.2023.
//

import Foundation
import UIKit

class NeonPaywallFeature{
    
    static var arrFeatures = [NeonPaywallFeature]()
    
    internal init(title: String = String(), icon: UIImage = UIImage()) {
        self.title = title
        self.icon = icon
    }

    var title = String()
    var icon = UIImage()
   
}
