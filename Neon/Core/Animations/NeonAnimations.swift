//
//  NeonAnimations.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit

let scheduler = ActionScheduler()

extension UIView {
    
    public func animate(type: AnimationType, duration: TimeInterval = 0.5, delay: TimeInterval = 0) {
        switch type {
        case .fadeIn:
            fadeIn(duration: duration, delay: delay)
        case .fadeOut:
            fadeOut(duration: duration, delay: delay)
        case .scaleIn:
            scaleIn(duration: duration, delay: delay)
        case .slideInTop:
            slideIn(from: .top, duration: duration, delay: delay)
        case .slideInBottom:
            slideIn(from: .bottom, duration: duration, delay: delay)
        case .slideInRight:
            slideIn(from: .right, duration: duration, delay: delay)
        case .slideInLeft:
            slideIn(from: .left, duration: duration, delay: delay)
        case .fadeInAndSlideInTop:
            fadeInAndSlideIn(from: .top, duration: duration, delay: delay)
        case .fadeInAndSlideInBottom:
            fadeInAndSlideIn(from: .bottom, duration: duration, delay: delay)
        case .fadeInAndSlideInRight:
            fadeInAndSlideIn(from: .right, duration: duration, delay: delay)
        case .fadeInAndSlideInLeft:
            fadeInAndSlideIn(from: .left, duration: duration, delay: delay)
        case .bounce:
            bounce(duration: duration, delay: delay)
        }
    }
    
    private func fadeIn(duration: TimeInterval, delay: TimeInterval) {
        self.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                self.alpha = 1
            }, completion: nil)
        })
        
    }
    
    private func fadeOut(duration: TimeInterval, delay: TimeInterval) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                self.alpha = 0
            }, completion: nil)
        })
        
    }
    
    private func scaleIn(duration: TimeInterval, delay: TimeInterval) {
        self.transform = CGAffineTransform(scaleX: 0, y: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        })
    }
    
    private func slideIn(from direction: SlideDirection, duration: TimeInterval, delay: TimeInterval) {
        
        if self.isHidden == true{
            return
        }
        
        self.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.isHidden = false
            let originalFrame = self.frame
            switch direction {
            case .top:
                self.frame.origin.y -= UIScreen.main.bounds.height
            case .bottom:
                self.frame.origin.y += UIScreen.main.bounds.height
            case .left:
                self.frame.origin.x -= UIScreen.main.bounds.width
            case .right:
                self.frame.origin.x += UIScreen.main.bounds.width
            }
            
            
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                self.frame = originalFrame
            }, completion: nil)
        })
        
    }
    
    private func fadeInAndSlideIn(from direction: SlideDirection, duration: TimeInterval, delay: TimeInterval) {
        
        if self.isHidden == true{
            return
        }
        
        fadeIn(duration: duration, delay: delay)
        self.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            self.isHidden = false
            let originalFrame = self.frame
            switch direction {
            case .top:
                self.frame.origin.y -= 100
            case .bottom:
                self.frame.origin.y += 100
            case .left:
                self.frame.origin.x -= 100
            case .right:
                self.frame.origin.x += 100
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: [], animations: {
                self.frame = originalFrame
            }, completion: nil)
        })
        
    }
    
    private func bounce(duration: TimeInterval, delay: TimeInterval, springDamping: CGFloat = 0.9, initialSpringVelocity: CGFloat = 0.3) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: [], animations: {
                // Add keyframe for scaling up
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                    self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                }
                
                // Add keyframe for scaling back to original size
                UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                    self.transform = CGAffineTransform.identity
                }
            }, completion: nil)
        })
        
        
    }
    enum SlideDirection {
        case top, bottom, left, right
    }
    
    // Tween
    
    
    public func changeColor(to: UIColor,
                    duration: TimeInterval,
                    easing: Easing,
                     delay : TimeInterval? = nil){
        let action = InterpolationAction(
            from: self.backgroundColor ?? .clear,
            to: to,
            duration: duration,
            easing: easing) {
            [unowned self] in self.backgroundColor = $0
        }
        if (delay != nil){
            DispatchQueue.main.asyncAfter(deadline: .now() + delay!, execute: {
                scheduler.run(action: action)
            })
        }else{
            scheduler.run(action: action)
        }
     
      

    }
    
    public func rotate(angle : Double, duration: Double, delay : TimeInterval = 0){
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: duration, animations: {
                let rotationTransform = CGAffineTransform(rotationAngle: angle)
                self.transform = self.transform.concatenating(rotationTransform)
            })
        })
    }
    
    public func scale(x : Double, y : Double, duration: Double, delay : TimeInterval = 0){
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            UIView.animate(withDuration: duration, animations: {
                let scaleTransform = CGAffineTransform(scaleX: x, y: y)
                self.transform = self.transform.concatenating(scaleTransform)
            })
        })
    }
    
    public func arc(radius: CGFloat,
             degrees: Double,
             duration: Double,
             easing: Easing,
             repeat : NeonAnimationRepeat? = nil,
             delay : TimeInterval = 0) {

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            
            
            let action =  ArcAction(center: CGPoint(x: self.center.x  , y: self.center.y  + (radius)),
                                    radius: radius,
                                    startDegrees: 0,
                                    endDegrees: 0 + degrees,
                                    duration: duration) { position in
                self.center = position
             }
     
        
                if let `repeat`{
                    switch `repeat` {
                    case .forever:
                        scheduler.run(action: action.yoyo().repeatedForever())
                    case .times(let count):
                        scheduler.run(action: action.yoyo().repeated(count))
                    }
                }else{
                    scheduler.run(action: action)
                }
            })
  
     }
    
    public func shift(to direction: NeonAnimationDirection,
               distance: CGFloat,
               duration: Double,
               easing: Easing,
               repeat : NeonAnimationRepeat? = nil,
               delay : TimeInterval = 0) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
            
            let (axis, delta) = self.axisAndDelta(for: direction, distance: distance, actionType: .shift)
         let targetValue = self.center[keyPath: axis] + delta

         let action = InterpolationAction(
            from: self.center[keyPath: axis],
            to: targetValue,
            duration: duration,
            easing: easing) {
             self.center[keyPath: axis] = $0
         }
    
                if let `repeat`{
                    switch `repeat` {
                    case .forever:
                        scheduler.run(action: action.yoyo().repeatedForever())
                    case .times(let count):
                        scheduler.run(action: action.yoyo().repeated(count))
                    }
                }else{
                    scheduler.run(action: action)
                }
            })
  
     }
    
    public func bring(from direction: NeonAnimationDirection,
               distance: CGFloat,
               duration: Double,
               easing: Easing,
               repeat : NeonAnimationRepeat? = nil,
               delay : TimeInterval = 0) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [self] in
            
        let (axis, delta) = axisAndDelta(for: direction, distance: distance, actionType: .bring)
            let startPoint = self.center[keyPath: axis] - delta
            let endPoint = self.center[keyPath: axis]

            let action = InterpolationAction(from: startPoint, to: endPoint, duration: duration, easing: easing) {
                self.center[keyPath: axis] = $0
            }
        
                if let `repeat`{
                    switch `repeat` {
                    case .forever:
                        scheduler.run(action: action.yoyo().repeatedForever())
                    case .times(let count):
                        scheduler.run(action: action.yoyo().repeated(count))
                    }
                }else{
                    scheduler.run(action: action)
                }
            })
     }
    
    enum ActionType {
        case shift
        case bring
    }

    private func axisAndDelta(for direction: NeonAnimationDirection, distance: CGFloat, actionType: ActionType) -> (WritableKeyPath<CGPoint, CGFloat>, CGFloat) {
        let isShiftAction = actionType == .shift

        switch direction {
        case .left:
            return (\CGPoint.x, isShiftAction ? -distance : distance)
        case .right:
            return (\CGPoint.x, isShiftAction ? distance : -distance)
        case .up:
            return (\CGPoint.y, isShiftAction ? -distance : distance)
        case .down:
            return (\CGPoint.y, isShiftAction ? distance : -distance)
        }
    }


    
}

public enum NeonAnimationRepeat{
    case forever
    case times(Int)
}
    
public enum NeonAnimationDirection{
    case left
    case right
    case up
    case down
}
    

public enum AnimationType {
    case fadeIn
    case fadeOut
    case scaleIn
    case slideInTop
    case slideInBottom
    case slideInRight
    case slideInLeft
    case fadeInAndSlideInTop
    case fadeInAndSlideInBottom
    case fadeInAndSlideInRight
    case fadeInAndSlideInLeft
    case bounce
}
