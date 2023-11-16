//
//  NeonLongOnboardingProgressView.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import UIKit
import Foundation
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingProgressView: UIView {
    
    // Define color properties
    var upcomingProgressBackgroundColor: UIColor = .white
    var upcomingProgressTextColor: UIColor = .black
    var completedProgressBackgroundColor: UIColor = .black
    var completedProgressTextColor: UIColor = .white
    
    private let title: String
    private var circles = [UIView]()
    private var lines = [UIView]()
    private var currentIndex: Int
    private var numberOfSteps: Int
    let titleLabel = UILabel()
    // Take the current index and number of steps as parameters
    init(title: String, currentIndex: Int, numberOfSteps: Int) {
        self.currentIndex = currentIndex
        self.numberOfSteps = numberOfSteps
        self.title = title
        super.init(frame: CGRect.zero)
        setupTitleLabel()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews() {
        for i in 1...numberOfSteps {
            let circle = UIView()
            circle.layer.cornerRadius = 15 // Adjust if circle size changes
            circle.backgroundColor = i <= currentIndex ? completedProgressBackgroundColor : upcomingProgressBackgroundColor
            addSubview(circle)
            circles.append(circle)
            
            let numberLabel = UILabel()
            numberLabel.textAlignment = .center
            numberLabel.font = Font.custom(size: 14, fontWeight: .SemiBold) // Adjust font size as needed
            
            if i < numberOfSteps {
                numberLabel.text = "\(i)"
                numberLabel.textColor = i <= currentIndex ? completedProgressTextColor : upcomingProgressTextColor
                circle.addSubview(numberLabel)
                
                numberLabel.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            } else {
                let checkmarkImageView = UIImageView(image: UIImage(systemName: "checkmark"))
                checkmarkImageView.tintColor = upcomingProgressTextColor
                
                if currentIndex == numberOfSteps{
                    checkmarkImageView.tintColor = completedProgressTextColor
                }
                circle.addSubview(checkmarkImageView)
                
                checkmarkImageView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            }
        }
        
        // Add constraints using SnapKit
        circles.enumerated().forEach { index, circle in
            circle.snp.makeConstraints { make in
                make.size.equalTo(CGSize(width: 30, height: 30)) // Increased size
                make.top.equalTo(titleLabel.snp.bottom).offset(20)
                
                if index == 0 {
                    make.left.equalToSuperview()
                } else {
                    let previousCircle = circles[index - 1]
                    make.left.equalTo(previousCircle.snp.right).offset(40) // Adjust spacing as needed
                }
                
                if index == numberOfSteps - 1 {
                    make.right.equalToSuperview()
                }
            }
        }
    }
    
    func setupTitleLabel(){
        

        // Create attributed string for title
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NeonLongOnboardingConstants.textColor,
            .font: Font.custom(size: 16, fontWeight: .SemiBold)
        ]
        let titleAttributedString = NSAttributedString(string: title, attributes: titleAttributes)

        // Create attributed string for progress
        let progressAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: NeonLongOnboardingConstants.textColor,
            .font: Font.custom(size: 16, fontWeight: .Regular)
        ]
        let progressText = "\(currentIndex)/\(numberOfSteps)"
        let progressAttributedString = NSAttributedString(string: progressText, attributes: progressAttributes)

        // Combine the attributed strings
        let combinedAttributedString = NSMutableAttributedString()
        combinedAttributedString.append(titleAttributedString)
        combinedAttributedString.append(NSAttributedString(string: " ")) // Add space between title and progress
        combinedAttributedString.append(progressAttributedString)

        // Set the combined attributed string to the label
        titleLabel.attributedText = combinedAttributedString
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
   
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Remove old layers to prevent duplicates
        layer.sublayers?.forEach {
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        }
        
        // Create the completed segment of the dashed line
        if currentIndex > 0 {
            let completedDashedLineLayer = CAShapeLayer()
            completedDashedLineLayer.strokeColor = completedProgressBackgroundColor.cgColor
            completedDashedLineLayer.lineWidth = 2
            completedDashedLineLayer.lineDashPattern = [6, 3]
            completedDashedLineLayer.fillColor = nil
            completedDashedLineLayer.zPosition = -1
            
            let completedLinePath = UIBezierPath()
            completedLinePath.move(to: CGPoint(x: circles.first!.frame.midX, y: circles.first!.frame.midY))
            
            // Draw the line only up to the current index circle center
            for i in 0..<currentIndex {
                completedLinePath.addLine(to: CGPoint(x: circles[i].frame.midX, y: circles[i].frame.midY))
            }
            
            completedDashedLineLayer.path = completedLinePath.cgPath
            layer.insertSublayer(completedDashedLineLayer, at: 0)
        }
        
        // Create the upcoming segment of the dashed line if there are more steps ahead
        if currentIndex < numberOfSteps {
            let upcomingDashedLineLayer = CAShapeLayer()
            upcomingDashedLineLayer.strokeColor = upcomingProgressBackgroundColor.cgColor
            upcomingDashedLineLayer.lineWidth = 2
            upcomingDashedLineLayer.lineDashPattern = [6, 3]
            upcomingDashedLineLayer.fillColor = nil
            upcomingDashedLineLayer.zPosition = -1
            
            let upcomingLinePath = UIBezierPath()
            // Start from the current index if it's the first one, start from its center.
            if currentIndex == 0 {
                upcomingLinePath.move(to: CGPoint(x: circles.first!.frame.midX, y: circles.first!.frame.midY))
            } else {
                upcomingLinePath.move(to: CGPoint(x: circles[currentIndex - 1].frame.midX, y: circles[currentIndex - 1].frame.midY))
            }
            
            // Draw the line from the current step to the end
            for i in currentIndex..<numberOfSteps {
                upcomingLinePath.addLine(to: CGPoint(x: circles[i].frame.midX, y: circles[i].frame.midY))
            }
            
            upcomingDashedLineLayer.path = upcomingLinePath.cgPath
            layer.addSublayer(upcomingDashedLineLayer)
        }
    }
    
}





