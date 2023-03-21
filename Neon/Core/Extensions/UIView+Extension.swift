//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit

extension UIView{
    
    public func lastSubview() -> UIView?{
        if let lastSubview = self.subviews.last{
            return lastSubview
        }else{
            return nil
        }
    }
}
