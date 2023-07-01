//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import Hero
import UIKit

extension UIViewController { // Presentation
    
    public enum Direction {
        case right
        case left
        case up
        case down
    }
    
    public func present(destinationVC: UIViewController, slideDirection: Direction) {
        switch slideDirection {
        case .left:
            destinationVC.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .right), dismissing: .slide(direction: .left))
        case .right:
            destinationVC.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .left), dismissing: .slide(direction: .right))
        case .up:
            destinationVC.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .up), dismissing: .slide(direction: .down))
        case .down:
            destinationVC.hero.modalAnimationType = .selectBy(presenting: .slide(direction: .down), dismissing: .slide(direction: .up))
        }

        destinationVC.isHeroEnabled = true
        destinationVC.modalPresentationStyle = .fullScreen
        self.present(destinationVC, animated: true)
        
    }

    public func presentWithoutAnimation(destinationVC: UIViewController) {
        destinationVC.modalPresentationStyle = .fullScreen
         self.present(destinationVC, animated: false)
    }

    public func presentAsPageSheet(destinationVC: UIViewController) {
        destinationVC.modalPresentationStyle = .pageSheet
         self.present(destinationVC, animated: true)
    }
}

#if !os(xrOS)
extension UIViewController{
    
    public func vibrate(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
}
#endif
