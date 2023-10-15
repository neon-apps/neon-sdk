//
//  NeonOnboardingPage.swift
//  Neon Educations
//
//  Created by Tuna Öztürk on 15.10.2023.
//

import Foundation
import UIKit

class NeonOnboardingPage{
    
    internal init(title: String = String(), subtitle: String = String(), image: UIImage = UIImage()) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
    }
    
    
    var title = String()
    var subtitle = String()
    var image = UIImage()
    var id = UUID().uuidString
    var index = Int()
}
