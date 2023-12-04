//
//  NeonPaywallFeaturesCell.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 8.06.2023.
//

import Foundation
import UIKit

class NeonPaywallFeatureCell: NeonTableViewCell<NeonPaywallFeature> {
    
    public let titleLabel = UILabel()
    public let imgIcon = UIImageView()
    public let imgIconBackground = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func configure(with feature: NeonPaywallFeature) {
        super.configure(with: feature)
        titleLabel.text = feature.title
            if let image = feature.icon{
                imgIcon.image = image.withRenderingMode(.alwaysTemplate)
            }else if let url = feature.iconURL{
                imgIcon.setImage(urlString: url)
                
        }
    }
  
    private func setupSubviews() {
        
        layer.masksToBounds = true
        backgroundColor = .clear
        
        
     
        contentView.addSubview(imgIconBackground)
        imgIconBackground.layer.cornerRadius = 10
        imgIconBackground.contentMode = .scaleAspectFit
        imgIconBackground.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(55)
            make.width.height.equalTo(self.snp.height).inset(5)
            make.centerY.equalToSuperview()
        }
        
        contentView.addSubview(imgIcon)
        imgIcon.contentMode = .scaleAspectFit
        imgIcon.snp.makeConstraints { make in
            make.width.height.equalTo(15)
            make.center.equalTo(imgIconBackground)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.font = Font.custom(size: 13, fontWeight: .Medium)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imgIconBackground.snp.right).offset(20)
            make.centerY.equalTo(imgIconBackground)
        }
   
        
        

    }
    
    
}
