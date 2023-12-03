//
//  NeonLongPaywallTimetine.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 2.12.2023.
//

import Foundation
import UIKit

public class NeonLongPaywallTimelineItem{
    var icon : UIImage
    var title = String()
    var subtitle = String()
    var description = String()
    
    public init(icon: UIImage, title: String, subtitle: String,  description: String) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.description = description
    }
}
