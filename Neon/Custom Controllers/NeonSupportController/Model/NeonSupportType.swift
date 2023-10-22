//
//  NeonSupportType.swift
//  WatermarkRemover
//
//  Created by Tuna Öztürk on 21.10.2023.
//

import Foundation
import UIKit

class NeonSupportType {
    
    internal init(title: String, icon: UIImage, placeholder: String, ctaButtonTitle: String, controllerType: NeonSupportControllerConstants.ControllerType, successMessageTitle: String, successMessage: String) {
        self.title = title
        self.icon = icon
        self.placeholder = placeholder
        self.ctaButtonTitle = ctaButtonTitle
        self.controllerType = controllerType
        self.successMessageTitle = successMessageTitle
        self.successMessage = successMessage
    }
    
    var title: String
    var icon: UIImage
    var placeholder: String
    var ctaButtonTitle: String
    var controllerType: NeonSupportControllerConstants.ControllerType
    var successMessageTitle: String
    var successMessage: String
}


