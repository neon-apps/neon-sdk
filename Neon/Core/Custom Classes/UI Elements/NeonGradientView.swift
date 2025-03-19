//
//  File.swift
//  Neon
//
//  Created by Tyler Blackford on 3/19/25.
//

import Foundation
import UIKit

public class NeonGradientView: UIView {
    
    public enum GradientDirection {
        case vertical
        case horizontal
    }
    
    private let gradientLayer = CAGradientLayer()
    public var direction: GradientDirection = .vertical

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGradient()
    }
    
    private func setupGradient() {
        layer.insertSublayer(gradientLayer, at: 0)
    }

    public func configure(stops: [(CGFloat, UIColor)], direction: GradientDirection = .vertical) {
        self.direction = direction
        updateGradientDirection()
        
        let colors = stops.map { $0.1.cgColor }
        let locations = stops.map { NSNumber(value: Float($0.0)) }
        
        gradientLayer.colors = colors
        gradientLayer.locations = locations
    }
    
    public func layout() {
        gradientLayer.frame = bounds
    }
    
    private func updateGradientDirection() {
        switch direction {
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        }
    }
}
