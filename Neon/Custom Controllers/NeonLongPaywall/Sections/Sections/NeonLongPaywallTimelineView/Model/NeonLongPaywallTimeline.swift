//
//  NeonLongPaywallTimetine.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 2.12.2023.
//

import Foundation
import UIKit

public class NeonLongPaywallTimelineItem{
   public var icon : UIImage?
   public var iconURL : String?
   public var title = String()
   public var subtitle = String()
   public var description = String()
    
    public init(icon: UIImage, title: String, subtitle: String,  description: String) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.description = description
    }
    
    public init(iconURL: String, title: String, subtitle: String,  description: String) {
        self.iconURL = iconURL
        self.title = title
        self.subtitle = subtitle
        self.description = description
    }
}
