//
//  NeonLongOnboardingOption.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit


public class NeonLongOnboardingOption{
    
    public init(title: String, emoji: String) {
        self.title = title
        self.emoji = emoji
    }
    
    public init(title: String, icon: UIImage) {
        self.title = title
        self.icon = icon
    }
    
    var title : String
    var emoji : String?
    var icon : UIImage?
}
