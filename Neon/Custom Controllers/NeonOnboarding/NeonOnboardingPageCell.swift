//
//  NeonOnboardingPageCell.swift
//  Neon Educations
//
//  Created by Tuna Öztürk on 15.10.2023.
//

import Foundation
import NeonSDK
import UIKit

class NeonOnboardingPageCell: NeonCollectionViewCell<NeonOnboardingPage> {
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    static var titleColor : UIColor = .white
    static var subtitleColor : UIColor = .white
    static var titleFont : UIFont = Font.custom(size: 30, fontWeight: .Bold)
    static var subtitleFont : UIFont = Font.custom(size: 20, fontWeight: .Medium)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with page: NeonOnboardingPage) {
        super.configure(with: page)
        titleLabel.text = page.title
        titleLabel.textAlignment = .center
        titleLabel.font = NeonOnboardingPageCell.titleFont
        titleLabel.textColor = NeonOnboardingPageCell.titleColor
        
        subtitleLabel.text = page.subtitle
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = NeonOnboardingPageCell.subtitleFont
        subtitleLabel.textColor = NeonOnboardingPageCell.subtitleColor
        
    }
  
    private func setupSubviews() {
        
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.alignment = .center
        verticalStack.distribution = .equalSpacing
        contentView.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
        verticalStack.addArrangedSubview(UIView())
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(subtitleLabel)
        verticalStack.addArrangedSubview(UIView())
  
    }
}
