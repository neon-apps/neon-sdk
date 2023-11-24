//
//  NeonLongOnboardingGreatFitBenefitView.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonLongOnboardingGreatFitBenefitView: UIView {
    
    let titleLabel = UILabel()
    let emojiLabel = UILabel()
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        
    }

    private func setupViews() {
        
        
        emojiLabel.font = Font.custom(size: 50, fontWeight: .Medium)
        addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
      
        
        titleLabel.textColor = NeonLongOnboardingConstants.textColor
        titleLabel.font = Font.custom(size: 14, fontWeight: .SemiBold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emojiLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }
        titleLabel.sizeToFit()
    }
    
 
    // MARK: - Public Methods
    func configure(benefit : NeonLongOnboardingGreatFitBenefit) {
        titleLabel.text = benefit.title
        emojiLabel.text = benefit.emoji
    }
    
    func rotate(degree : CGFloat){
        let rotationAngle = degree * CGFloat.pi / 180
        emojiLabel.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
}
