//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit

public class AlertButton : NSObject{
    public init(title: String = "Okay", style : UIAlertAction.Style = .default , completion: @escaping () -> ()) {
        self.title = title
        self.completion = completion
        self.style = style
        
    }
    public var title = String()
    public var completion: () -> ()
    public var style : UIAlertAction.Style = .default
}
