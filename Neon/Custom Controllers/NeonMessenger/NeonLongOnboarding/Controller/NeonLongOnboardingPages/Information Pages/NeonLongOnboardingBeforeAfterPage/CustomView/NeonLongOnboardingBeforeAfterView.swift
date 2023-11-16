//
//  NeonLongOnboardingBeforeAfterView.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class BeforeAfterView: UIView {
    
    private let titleLabel = UILabel()
    let stackView = UIStackView()
    private var items: [String]
    
    var animationDelay = 1.3
    init(type : ViewType, title: String, items: [String]) {
        self.items = items
        self.type = type
        super.init(frame: .zero)
        setupViews(title)
        setupStackView()
        configureConstraints()
        self.layer.cornerRadius = 20
        self.layer.masksToBounds = false
    }
    
    enum ViewType{
        case before
        case after
    }
    var type = ViewType.before
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(_ title: String) {
       
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        if type == .before{
            imageView.image = UIImage(named: "img_cloud", in: Bundle.module, compatibleWith: nil)
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(96)
                make.centerY.equalTo(self.snp.top)
                make.right.equalTo(self.snp.right).inset(20)
            }
        }else{
            imageView.image = UIImage(named: "img_sun", in: Bundle.module, compatibleWith: nil)
            imageView.snp.makeConstraints { make in
                make.width.height.equalTo(96)
                make.top.equalTo(self.snp.top).offset(-30)
                make.right.equalTo(self.snp.right).inset(10)
            }
        }
        animationDelay += 0.1
        imageView.animate(type: .fadeIn, delay: animationDelay)
       
        
        titleLabel.text = title
        titleLabel.textColor = NeonLongOnboardingConstants.textColor
        titleLabel.font = Font.custom(size: 30, fontWeight: .SemiBold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        animationDelay += 0.1
        titleLabel.animate(type: .fadeIn, delay: animationDelay)
    }
    
    @available(iOS 13.0, *)
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 30
        
        
        for item in items {
            let itemLabel = UILabel()
            itemLabel.text = item
            itemLabel.textColor = NeonLongOnboardingConstants.textColor
            itemLabel.font = Font.custom(size: 14, fontWeight: .Medium)
            itemLabel.numberOfLines = 0
            
            let crossImageView = UIImageView()
            crossImageView.contentMode = .scaleAspectFit
            crossImageView.tintColor = NeonLongOnboardingConstants.textColor
            crossImageView.snp.makeConstraints { make in
                make.width.height.equalTo(16)
            }
            
            
            if type == .before{
                crossImageView.image = NeonSymbols.xmark
            }else{
                crossImageView.image = NeonSymbols.checkmark
            }
            
            
            let itemStackView = UIStackView(arrangedSubviews: [crossImageView, itemLabel])
            itemStackView.axis = .horizontal
            itemStackView.spacing = 8
            itemStackView.alignment = .center
            
            stackView.addArrangedSubview(itemStackView)
            
            animationDelay += 0.1
            itemStackView.animate(type: .fadeIn, delay: animationDelay)
        }
        
        addSubview(stackView)
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(18)
            make.trailing.equalToSuperview().offset(-18)
        }
    }
    
 
}
