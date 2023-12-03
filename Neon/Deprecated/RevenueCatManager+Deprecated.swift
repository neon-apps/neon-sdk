//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 3.12.2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
extension RevenueCatManager{
    
    @available(*, unavailable, renamed: "purchase")
    public static func subscribe(animation : LottieManager.AnimationType, animationColor : UIColor? = nil, animationWidth : Int? = nil,  completionSuccess: (() -> ())?, completionFailure: (() -> ())?) {}
}
