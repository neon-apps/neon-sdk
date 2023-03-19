//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import Hero
import UIKit

extension UIViewController {
    
    enum Direction {
        case right
        case left
        case up
        case down
    }
    
     func present(destinationVC: UIViewController, slideDirection: Direction) {
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

     func presentWithoutAnimation(destinationVC: UIViewController) {
        destinationVC.modalPresentationStyle = .fullScreen
         self.present(destinationVC, animated: false)
    }

     func presentAsPageSheet(destinationVC: UIViewController) {
        destinationVC.modalPresentationStyle = .pageSheet
         self.present(destinationVC, animated: true)
    }
}
