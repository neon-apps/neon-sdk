//
//  NeonBouncingButton.swift
//  NeonSDK
//
//  Created by Tuna Öztürk on 8.06.2023.
//

import UIKit

public class NeonBouncingButton: UIButton {
    
    /// The default value for bouncingScale is 1.15
    public var bouncingScale = 1.15
    
    /// The default value for bouncingDuration is 0.8
    public var bouncingDuration = 0.8
 
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public func commonInit() {
        originalTransform = transform
        addBouncingAnimation()
    }
    
    private var originalTransform: CGAffineTransform!
    private var bouncingAnimation: UIViewPropertyAnimator!
    
    private func addBouncingAnimation() {
        bouncingAnimation = UIViewPropertyAnimator(duration: bouncingDuration, curve: .easeInOut) { [self] in
            self.transform = self.originalTransform.scaledBy(x: bouncingScale, y: bouncingScale)
        }
        bouncingAnimation.addAnimations({
            self.transform = self.originalTransform
        }, delayFactor: 0.4)
        bouncingAnimation.addCompletion { _ in
            self.addBouncingAnimation()
        }
        bouncingAnimation.startAnimation()
    }
}
