//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit

class AlertButton{
    internal init(title: String = String(), style : UIAlertAction.Style = .default , completion: @escaping () -> ()) {
        self.title = title
        self.completion = completion
        self.style = style
        
    }
    var title = String()
    var completion: () -> ()
    var style : UIAlertAction.Style = .default
}
