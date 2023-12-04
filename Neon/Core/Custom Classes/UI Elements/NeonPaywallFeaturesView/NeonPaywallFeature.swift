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
    
    public init(title: String, icon: UIImage) {
        self.title = title
        self.icon = icon
    }
    
    public init(title: String, iconURL: String) {
        self.title = title
        self.iconURL = iconURL
    }
    

    public var title = String()
    public var icon : UIImage?
    public var iconURL : String?
}
