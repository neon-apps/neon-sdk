//
//  NeonSupportTypeCell.swift
//  WatermarkRemover
//
//  Created by Tuna Öztürk on 21.10.2023.
//

import Foundation
import UIKit
import NeonSDK

class NeonSupportTypeCell: NeonCollectionViewCell<NeonSupportType> {
    
    
    let imgIcon = UIImageView()
    let lblTitle = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func configure(with type: NeonSupportType) {
        super.configure(with: type)
        imgIcon.image = type.icon
        lblTitle.text = type.title
        
        if NeonSupportControllerConstants.choosenSupportType.title != type.title{
            contentView.layer.borderWidth = 0
        }else{
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = NeonSupportControllerConstants.mainColor.cgColor
        }
    }
  
    private func setupSubviews() {
        
        contentView.backgroundColor = NeonSupportControllerConstants.containerColor
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
    
        
        contentView.addSubview(lblTitle)
        lblTitle.font = Font.custom(size: 13, fontWeight: .Medium)
        lblTitle.textAlignment = .center
        lblTitle.textColor = NeonSupportControllerConstants.textColor
        lblTitle.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.centerY.equalToSuperview()
        }
        lblTitle.sizeToFit()
        
        contentView.addSubview(imgIcon)
        imgIcon.contentMode = .scaleAspectFit
        imgIcon.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview()
            make.left.equalTo(lblTitle.snp.right).offset(10)
            make.right.equalToSuperview().inset(14)
        }
     
      
    }
    
    
}
