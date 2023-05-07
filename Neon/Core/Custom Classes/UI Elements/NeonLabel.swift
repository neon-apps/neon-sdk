//
//  File 3.swift
//  
//
//  Created by Tuna Öztürk on 3.04.2023.
//

import Foundation
import UIKit
import Localize_Swift

class NeonLabel: UILabel {
    override var text: String? {
        get {
            return super.text
        }
        set {
            super.text = newValue?.localized()
        }
    }
}
