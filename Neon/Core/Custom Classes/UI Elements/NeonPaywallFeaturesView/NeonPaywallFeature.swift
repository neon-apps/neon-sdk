//
//  NeonPaywallFeature.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 8.06.2023.
//

import Foundation
import UIKit

public class NeonPaywallFeature{
    
    static var arrFeatures = [NeonPaywallFeature]()
    
    public init(title: String = String(), icon: UIImage = UIImage()) {
        self.title = title
        self.icon = icon
    }

    public var title = String()
    public var icon = UIImage()
   
}
