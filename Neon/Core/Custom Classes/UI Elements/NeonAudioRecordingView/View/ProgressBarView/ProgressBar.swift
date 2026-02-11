//
//  ProgressBar.swift
//  FaceDance
//
//  Created by Tuna Öztürk on 3.08.2024.
//



import Foundation
import UIKit
import NeonSDK

public class ProgressBar: UIView {
    
    public var trackColor: UIColor = .gray {
        didSet {
            trackLayer.strokeColor = trackColor.cgColor
        }
    }
    
    public var gradients: [UIColor] = [NeonAudioRecordingViewConstants.progressBarTintColor, NeonAudioRecordingViewConstants.progressBarTintColor] {
        didSet {
            let gradientColors = gradients.map { $0.cgColor }
            pulsingGradientLayer.colors = gradientColors
            shapeGradientLayer.colors = gradientColors
        }
    }
    
    public var lineHeight: CGFloat = 10 {
        didSet {
            trackLayer.lineWidth = lineHeight
            shapeLayer.lineWidth = lineHeight
        }
    }
    
    public var lineDashPattern: [NSNumber] = [1, 0] {  // lineWidth, lineGap
        didSet {
            trackLayer.lineDashPattern = lineDashPattern
            shapeLayer.lineDashPattern = lineDashPattern
        }
    }
    
    public var textColor: UIColor = UIColor.white {
        didSet {
            progressLbl.textColor = textColor
        }
    }
        
    public var progress: Double = 0 {
        didSet {
            updateProgress()
        }
    }
    
    var pulsingGradientLayer: CAGradientLayer!  // Masking layer
    var pulsingLayer: CAShapeLayer!
    
    var trackLayer: CAShapeLayer!
    
    var shapeGradientLayer: CAGradientLayer!    // masking layer
    var shapeLayer: CAShapeLayer!
    
    lazy var progressLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = textColor
        lbl.textAlignment = .center
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        pulsingGradientLayer = createGradientLayer(colors: gradients)  // Masking layer
        self.layer.addSublayer(pulsingGradientLayer)
        
        pulsingLayer = createShapeLayer(strokeColor: UIColor(white: 0, alpha: 0.2), fillColor: .clear)
        pulsingLayer.lineWidth = 0
        pulsingLayer.lineDashPattern = nil
        self.layer.addSublayer(pulsingLayer)
        
        pulsingGradientLayer.mask = pulsingLayer
        
        trackLayer = createShapeLayer(strokeColor: trackColor, fillColor: .clear)
        trackLayer.strokeEnd = 1
        self.layer.addSublayer(trackLayer)
        
        shapeGradientLayer = createGradientLayer(colors: gradients)  // Masking layer
        self.layer.addSublayer(shapeGradientLayer)
        
        shapeLayer = createShapeLayer(strokeColor: .black, fillColor: .clear)
        shapeLayer.strokeEnd = CGFloat(progress)
        self.layer.addSublayer(shapeLayer)
        
        shapeGradientLayer.mask = shapeLayer
        
        self.addSubview(progressLbl)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        pulsingGradientLayer.frame = self.bounds
        shapeGradientLayer.frame = self.bounds
        progressLbl.frame = self.bounds
        
        let cx = self.bounds.width / 2
        let cy = self.bounds.height / 2
        let viewCenter = CGPoint(x: cx, y: cy)
        
        let radius = min(cx, cy) - (lineHeight * 2)
        
        let path = UIBezierPath(arcCenter: .zero, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        pulsingLayer.path = path.cgPath
        trackLayer.path = path.cgPath
        shapeLayer.path = path.cgPath
        
        pulsingLayer.position = viewCenter
        trackLayer.position = viewCenter
        shapeLayer.position = viewCenter
        
        trackLayer.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
        shapeLayer.transform = CATransform3DMakeRotation(-.pi/2, 0, 0, 1)
    }
    
    func updateProgress() {
        shapeLayer.strokeEnd = CGFloat(progress)
  
    }
    
    func startPulseAnimation() {
        pulsingLayer.lineWidth = lineHeight
        
        
        let scaleXY = 1 + (lineHeight/100)
        let animation =  CABasicAnimation(keyPath: "transform.scale.xy")
        animation.toValue = scaleXY
        animation.duration = 0.8
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        
        pulsingLayer.add(animation, forKey: "TYPulsing")
    }
    
    func stopPulseAnimation() {
        pulsingLayer.lineWidth = 0
        pulsingLayer.removeAnimation(forKey: "TYPulsing")
    }
    
    func createShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer {
        let layer = CAShapeLayer()
        layer.lineWidth = lineHeight
        layer.strokeColor = strokeColor.cgColor
        layer.fillColor = fillColor.cgColor
        layer.lineDashPattern = lineDashPattern
        return layer
    }
    
    func createGradientLayer(colors: [UIColor]) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        let defaultColors = colors.map { $0.cgColor }
        gradientLayer.colors = defaultColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        return gradientLayer
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
