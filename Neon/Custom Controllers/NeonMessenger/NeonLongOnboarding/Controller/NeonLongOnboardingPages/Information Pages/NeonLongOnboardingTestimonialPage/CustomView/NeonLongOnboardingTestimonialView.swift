//
//  NeonLongOnboardingTestimonialView.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 15.11.2023.
//

import Foundation
import UIKit
import SnapKit
import NeonSDK
@available(iOS 13.0, *)
class NeonLongOnboardingTestimonialView: UIView {
    
    public let titleLabel = UILabel()
    public let testimonialLabel = UILabel()
    public let imgStars = UIImageView()
    public let authorLabel = UILabel()
    public let peopleEmojis = ["👱", "🧑", "👩", "🧔", "👵", "👴", "🧒", "👦", "👧", "👨‍🦳", "👩‍🦳", "👨‍🦱", "👩‍🦱", "👨‍🦰", "👩‍🦰", "👨‍🦲", "👩‍🦲", "🧑‍🦳", "🧑‍🦲"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with testimonial: NeonTestimonial) {
        titleLabel.text = testimonial.title
        testimonialLabel.text = testimonial.testimonial
        authorLabel.text = "\(peopleEmojis.randomElement()!) " + testimonial.author
    }
  
    private func setupSubviews() {
        
        backgroundColor = NeonLongOnboardingConstants.optionBackgroundColor
        layer.cornerRadius = 10
        layer.masksToBounds = true
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let topSpacer = UIView() // Add top spacer view
        stackView.addArrangedSubview(topSpacer)
        
        stackView.addArrangedSubview(authorLabel)
        authorLabel.font = Font.custom(size: 15, fontWeight: .Medium)
        authorLabel.textAlignment = .left
        authorLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
        
        stackView.addArrangedSubview(imgStars)
        imgStars.image = UIImage(named: "img_stars", in: Bundle.module, compatibleWith: nil)
        imgStars.contentMode = .scaleAspectFit
        imgStars.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
        }
        
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = Font.custom(size: 15, fontWeight: .SemiBold)
        titleLabel.textAlignment = .left
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
       
        stackView.addArrangedSubview(testimonialLabel)
        testimonialLabel.font = Font.custom(size: 12, fontWeight: .Regular)
        testimonialLabel.numberOfLines = 3
        testimonialLabel.textAlignment = .left
        testimonialLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
        
      
        
        let bottomSpacer = UIView() // Add bottom spacer view
        stackView.addArrangedSubview(bottomSpacer)
    }
}
