//
//  NeonTestimonialCell.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//
#if !os(xrOS)
import Foundation
import UIKit

class NeonTestimonialCell: NeonCollectionViewCell<NeonTestimonial> {
    
    public let titleLabel = UILabel()
    public let testimonialLabel = UILabel()
    public let imgStars = UIImageView()
    public let authorLabel = UILabel()
    public let stackView = UIStackView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func configure(with testimonial: NeonTestimonial) {
        super.configure(with: testimonial)
        titleLabel.text = testimonial.title
        testimonialLabel.text = testimonial.testimonial
        authorLabel.text = testimonial.author
    }
  
    private func setupSubviews() {
        
        layer.masksToBounds = true
        
       
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        contentView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }
        
        let topSpacer = UIView() // Add top spacer view
        stackView.addArrangedSubview(topSpacer)
        stackView.addArrangedSubview(titleLabel)
        titleLabel.font = Font.custom(size: 15, fontWeight: .SemiBold)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
        stackView.addArrangedSubview(imgStars)
        imgStars.image = UIImage(named: "img_stars", in: Bundle.module, compatibleWith: nil)
        imgStars.contentMode = .scaleAspectFit
        
       
        imgStars.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
        }
        stackView.addArrangedSubview(testimonialLabel)
        testimonialLabel.font = Font.custom(size: 12, fontWeight: .Regular)
        testimonialLabel.numberOfLines = 3
        testimonialLabel.textAlignment = .center
        testimonialLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
      
        
        stackView.addArrangedSubview(authorLabel)
        authorLabel.font = Font.custom(size: 15, fontWeight: .Medium)
        authorLabel.textAlignment = .center
        authorLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
        }
        
        let bottomSpacer = UIView() // Add bottom spacer view
        stackView.addArrangedSubview(bottomSpacer)
   
       
        
        
    }
    
    
}
#endif
