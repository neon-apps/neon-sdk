//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 4.06.2023.
//

import Foundation
import UIKit
import Lottie

class NeonAnimationView: UIView {
    
    private var animLoading: LottieAnimationView!
    private var viewTint: UIView?
    
    public init(animation: LottieManager.AnimationType, color: UIColor? = nil) {
        super.init(frame: .zero)
        
        let defaultAnimationName = animation.rawValue.name
        
        switch animation {
        case .custom(name: _):
            animLoading = LottieAnimationView(name: defaultAnimationName)
        default:
            let animationURL = Bundle.main.path(forResource: defaultAnimationName, ofType: "json")
            animLoading = LottieAnimationView(filePath: animationURL!)
        }
        
        animLoading.backgroundColor = .clear
        animLoading.loopMode = .loop
        animLoading.animationSpeed = 1
        animLoading.backgroundBehavior = .pauseAndRestore
        animLoading.play()
        
        if let color = color {
            viewTint = UIView(frame: animLoading.bounds)
            viewTint?.backgroundColor = color
            addSubview(viewTint!)
            viewTint?.mask = animLoading
        }
        
        addSubview(animLoading)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animLoading.frame = bounds
        viewTint?.frame = animLoading.bounds
    }
    
}
