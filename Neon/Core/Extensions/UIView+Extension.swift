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

enum GradientDirection {
    case horizontal
    case vertical
}

enum GradientStyle {
    case background
    case border(width: CGFloat)
}


extension UIView {
    func applyGradient(colors: [UIColor], direction: GradientDirection, style: GradientStyle) {
        
        
        self.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.cornerRadius = self.layer.cornerRadius
        
        switch direction {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
        }
        
        switch style {
        case .background:
            self.layer.insertSublayer(gradientLayer, at: 0)
        case .border(let width):
            let borderLayer = CAShapeLayer()
            borderLayer.lineWidth = width
            borderLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
            borderLayer.fillColor = UIColor.clear.cgColor
            borderLayer.strokeColor = UIColor.white.cgColor // Use any color
            gradientLayer.mask = borderLayer
            self.layer.addSublayer(gradientLayer)
        }
        
        
    }
}
