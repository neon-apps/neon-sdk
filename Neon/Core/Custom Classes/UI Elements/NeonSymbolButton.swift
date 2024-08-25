//
//  NeonSymbolButton.swift
//  AI Note Taker
//
//  Created by Tuna Öztürk on 24.08.2024.
//

import Foundation
import UIKit
import NeonSDK

public class NeonSymbolButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public func configure(with image : UIImage, tintColor : UIColor = .black) {
        setImage(image, for: .normal)
        self.tintColor = tintColor
        imageView?.contentMode  = .scaleAspectFit
        imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
        
    }
    
  
}

