//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 21.03.2023.
//

import Foundation
import UIKit

extension UIControl {
    @available(iOS 13.0, *)
    public func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        if #available(iOS 14.0, *) {
            addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
        } else {
            // Fallback on earlier versions
        }
    }
}

