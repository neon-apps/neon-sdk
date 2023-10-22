//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 3.04.2023.
//

import Foundation
import UIKit

public class NeonTextField : UITextField{
    
    public var contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInset)
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: contentInset)
    }
    
    public func setCustomPlaceholder(_ placeholder : String, color: UIColor){
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
    }
    
}
