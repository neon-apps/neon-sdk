//
//  File.swift
//
//
//  Created by Tuna Öztürk on 4.06.2023.
//
#if !os(xrOS)
import Foundation
import UIKit
import Lottie

public class NeonAnimationView: UIView {
    
    public var lottieAnimationView: LottieAnimationView!
    private var tintView: UIView?
    
    public init(animation: LottieManager.AnimationType, color: UIColor? = nil) {
        super.init(frame: .zero)
        
        let defaultAnimationName = animation.rawValue.name
        
        switch animation {
        case .custom(name: _):
            lottieAnimationView = LottieAnimationView(name: defaultAnimationName)
        default:
            let animationURL = Bundle.module.path(forResource: defaultAnimationName, ofType: "json")
            lottieAnimationView = LottieAnimationView(filePath: animationURL!)
        }
        
        lottieAnimationView.backgroundColor = .clear
        lottieAnimationView.loopMode = .loop
        lottieAnimationView.animationSpeed = 1
        lottieAnimationView.backgroundBehavior = .pauseAndRestore
        lottieAnimationView.play()
        addSubview(lottieAnimationView)

        if let color = color {
            tintView = UIView(frame: lottieAnimationView.bounds)
            tintView?.backgroundColor = color
            addSubview(tintView!)
            tintView?.mask = lottieAnimationView
        }
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        lottieAnimationView.frame = bounds
        tintView?.frame = lottieAnimationView.bounds
    }
    
}
#endif
