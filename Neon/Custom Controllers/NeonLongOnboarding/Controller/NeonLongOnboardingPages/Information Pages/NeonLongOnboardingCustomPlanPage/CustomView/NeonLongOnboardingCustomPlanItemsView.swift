//
//  NeonLongOnboardingCustomPlanItemsView.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingCustomPlanItemsView: UIView {
    
    // Assuming you want to display strings
    var items: [String] = [] {
        didSet {
            setupStackView()
        }
    }
    
    var animationDelay = 1.0
    private let horizontalStackView = UIStackView()
    private let verticalStackView = UIStackView()
    var verticalSpacing : CGFloat = 14{
        didSet{
            verticalStackView.spacing = verticalSpacing
        }
    }
    
    var textSize : CGFloat = 14{
        didSet{
            setupStackView()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        // Setup the vertical stack view properties
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 16
        verticalStackView.alignment = .leading
        verticalStackView.distribution = .equalSpacing
        
        // Add the vertical stack view to the view
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupStackView() {
        // Clear previous items
        verticalStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // Add new items to the vertical stack view
        for item in items {
            let label = UILabel()
            label.text = item
            label.textAlignment = .left
            label.numberOfLines = 0
            label.font = Font.custom(size: textSize, fontWeight: .Medium)
            label.textColor = NeonLongOnboardingConstants.textColor
    
            let tickLabel = UILabel()
            tickLabel.text = "✅" // Tick emoji
            tickLabel.font = UIFont.systemFont(ofSize: 20) // Set font size to 50
            
            let horizontalStackView = createHorizontalStackView()
            horizontalStackView.addArrangedSubview(tickLabel)
            horizontalStackView.addArrangedSubview(label)
         
            verticalStackView.addArrangedSubview(horizontalStackView)
            
           
            
        }
    }
    
    func animate(){
        for stackView in verticalStackView.subviews as! [UIView]{
            animationDelay += 0.1
            stackView.animate(type: .fadeInAndSlideInLeft, delay: animationDelay)
        }
      
    }

    private func createHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .top
        return stackView
    }

}
