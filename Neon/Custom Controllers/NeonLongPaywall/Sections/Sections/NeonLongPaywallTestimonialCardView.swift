//
//  NeonLongPaywallTestimonialCardView.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 19.11.2023.
//

import Foundation
import NeonSDK
import UIKit

@available(iOS 15.0, *)
class NeonLongPaywallTestimonialCardView : BaseNeonLongPaywallSectionView{
    
    
    var containerView = UIView()
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var authorLabel = UILabel()
    var starsImageView = UIImageView()
    var confettiImageView = UIImageView()
    
    override func configureSection(type: NeonLongPaywallSectionType) {
        
        
        
        
        switch type {
        case .testimonialCard(let title, let subtitle, let author, let overrideImage, let overrideImageWithURL):
            titleLabel.text = title
            subtitleLabel.text = subtitle
            if let author,  author != ""{
                authorLabel.text = "- \(author)"
            }
            if let overrideImage{
                confettiImageView.image = overrideImage
            }else if let overrideImageWithURL{
                confettiImageView.setImage(urlString: overrideImageWithURL)
            }else{
                confettiImageView.image = UIImage(named: "img_confeti", in: Bundle.module, compatibleWith: nil)
            }
            starsImageView.image = UIImage(named: "img_stars", in: Bundle.module, compatibleWith: nil)
            break
        default:
            fatalError("Something went wrong with NeonLongPaywall. Please consult to manager.")
        }
        configureView()
        setConstraint()
    }
    
    func configureView(){
        containerView.layer.borderWidth = manager.constants.containerBorderWidth
        containerView.layer.borderColor = manager.constants.containerBorderColor.cgColor
        containerView.backgroundColor = manager.constants.containerColor
        containerView.layer.cornerRadius = manager.constants.cornerRadius
        addSubview(containerView)
        
        
        containerView.addSubview(starsImageView)
        starsImageView.contentMode = .scaleAspectFit
        starsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.width.equalTo(100)
        }
        
        titleLabel.font = Font.custom(size: 16, fontWeight: .SemiBold)
        containerView.addSubview(titleLabel)
        titleLabel.textColor = manager.constants.primaryTextColor
        titleLabel.numberOfLines = 0
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(starsImageView.snp.bottom).offset(10)
            make.left.equalTo(starsImageView)
            make.right.equalToSuperview().offset(-20)
        }
        
        subtitleLabel.textColor = manager.constants.primaryTextColor
        subtitleLabel.font = Font.custom(size: 14, fontWeight: .Medium)
        subtitleLabel.numberOfLines = 0
        
        containerView.addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalTo(starsImageView)
            make.right.equalToSuperview().offset(-20)
            
        }
        authorLabel.textColor = manager.constants.primaryTextColor
        authorLabel.font = Font.custom(size: 12, fontWeight: .SemiBold)
        authorLabel.numberOfLines = 0
        
        containerView.addSubview(authorLabel)
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(10)
            make.left.equalTo(starsImageView)
            make.right.equalToSuperview().offset(-20)
            
            
        }
        
        
        containerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            if authorLabel.text == ""{
                make.bottom.equalTo(subtitleLabel.snp.bottom).offset(20)
            }else{
                make.bottom.equalTo(authorLabel.snp.bottom).offset(20)
            }
            
        }
        
        
        
        addSubview(containerView)
        
        addSubview(confettiImageView)
        confettiImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.size.equalTo(70)
        }
        
        
        
        
    }
    
    func setConstraint(){
        snp.makeConstraints { make in
            make.bottom.equalTo(containerView.snp.bottom)
        }
    }
    
}
