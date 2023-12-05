//
//  NeonSlideCell.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//
#if !os(xrOS)
import Foundation
import UIKit
import NeonSDK
class NeonSlideCell: NeonCollectionViewCell<NeonSlideItem> {
    
    public let titleLabel = UILabel()
    public let subtitleLabel = UILabel()
    public let firstImage = UIImageView()
    public let secondImage = UIImageView()
    let backgroundContentView = UIView()
    let lblBeforeBadge = NeonPaddingLabel()
    let lblAfterBadge = NeonPaddingLabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func configure(with slide: NeonSlideItem) {
        super.configure(with: slide)
        titleLabel.text = slide.title
        subtitleLabel.text = slide.subtitle
       if let firstImageURL = slide.firstImageURL, let secondImageURL = slide.secondImageURL{
            self.firstImage.setImage(urlString: firstImageURL)
            self.secondImage.setImage(urlString: secondImageURL)
        }else{
            self.firstImage.image = slide.firstImage
            self.secondImage.image = slide.secondImage
        }
      
       
    }
  
    private func setupSubviews() {
        
        layer.masksToBounds = true
        
       
        contentView.addSubview(backgroundContentView)
        backgroundContentView.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(10)
        }

        backgroundContentView.addSubview(subtitleLabel)
        subtitleLabel.font = Font.custom(size: 12, fontWeight: .Regular)
        subtitleLabel.numberOfLines = 0
        subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        subtitleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        subtitleLabel.textAlignment = .left
        subtitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(20)
    
        }

        
        backgroundContentView.addSubview(titleLabel)
        titleLabel.font = Font.custom(size: 15, fontWeight: .SemiBold)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        titleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(subtitleLabel.snp.top).offset(-5)
           
        }
  
        
        backgroundContentView.addSubview(firstImage)
        firstImage.contentMode = .scaleAspectFill
        firstImage.layer.masksToBounds = true
        firstImage.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        firstImage.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.right.equalTo(backgroundContentView.snp.centerX).offset(-5)
        }
        
        backgroundContentView.addSubview(secondImage)
        secondImage.contentMode = .scaleAspectFill
        secondImage.layer.masksToBounds = true
        secondImage.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.left.equalTo(backgroundContentView.snp.centerX).offset(5)
        }
   
       
        lblBeforeBadge.text = "BEFORE"
        lblBeforeBadge.font = Font.custom(size: 13, fontWeight: .Bold)
        lblBeforeBadge.numberOfLines = 0
        lblBeforeBadge.textAlignment = .center
        lblBeforeBadge.layer.cornerRadius = 4
        lblBeforeBadge.layer.masksToBounds = true
        backgroundContentView.addSubview(lblBeforeBadge)
        lblBeforeBadge.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(10)
        }
        lblBeforeBadge.leftInset = 6
        lblBeforeBadge.rightInset = 6
        lblBeforeBadge.topInset = 2
        lblBeforeBadge.bottomInset = 2
        
      
        lblAfterBadge.text = "AFTER"
        lblAfterBadge.font = Font.custom(size: 13, fontWeight: .Bold)
        lblAfterBadge.numberOfLines = 0
        lblAfterBadge.textAlignment = .center
        lblAfterBadge.layer.cornerRadius = 4
        lblAfterBadge.layer.masksToBounds = true
        backgroundContentView.addSubview(lblAfterBadge)
        lblAfterBadge.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(10)
        }
        lblAfterBadge.leftInset = 6
        lblAfterBadge.rightInset = 6
        lblAfterBadge.topInset = 2
        lblAfterBadge.bottomInset = 2
        
       
        
        
    }
    
    
}
#endif
