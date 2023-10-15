//
//  Messagecell.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 12.09.2023.
//

#if !os(xrOS)
import Foundation
import UIKit
import NeonSDK

class MessageCell: NeonTableViewCell<Message> {
    
    
  
    let lblMessage = UILabel()

    let imgPhoto = UIImageView()
    var container = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    

    override func configure(with message: Message) {
        super.configure(with: message)
        imgPhoto.setImage(urlString: message.sender.photoURL)
        lblMessage.text = message.content
        lblMessage.sizeToFit()
        
        if (message.sender == NeonMessengerManager.currentUser){
            configureCurrentUser()
        }else{
            configureConnection()
        }
    }
  
    private func setupSubviews() {
        
        backgroundColor = .clear
        
        contentView.addSubview(container)
        container.layer.cornerRadius = 10
 
        
        contentView.addSubview(imgPhoto)
        imgPhoto.contentMode = .scaleAspectFill
        imgPhoto.layer.cornerRadius = 19
        imgPhoto.layer.masksToBounds = true
        
        contentView.addSubview(lblMessage)
        lblMessage.font = Font.custom(size: 16, fontWeight: .Regular)
        lblMessage.textAlignment = .center
        lblMessage.textColor = NeonMessengerConstants.primaryTextColor
        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .left
    }
    
    func configureCurrentUser(){
        imgPhoto.snp.removeConstraints()
        imgPhoto.snp.makeConstraints { make in
            make.height.width.equalTo(38)
            make.right.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        lblMessage.snp.removeConstraints()
        lblMessage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalTo(imgPhoto.snp.left).offset(-20)
            make.left.greaterThanOrEqualToSuperview().inset(100)
            make.bottom.equalToSuperview().inset(20)
        }
        
        container.snp.removeConstraints()
        container.snp.makeConstraints { make in
            make.left.equalTo(lblMessage).offset(-10)
            make.right.equalTo(lblMessage).offset(10)
            make.top.equalTo(lblMessage).offset(-10)
            make.bottom.equalTo(lblMessage).offset(10)
           
        }
        
        container.backgroundColor = NeonMessengerConstants.currentUserMessageBackgroundColor
        container.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func configureConnection(){
        
        imgPhoto.snp.removeConstraints()
        imgPhoto.snp.makeConstraints { make in
            make.height.width.equalTo(38)
            make.left.equalToSuperview().inset(10)
            make.top.equalToSuperview().offset(10)
        }
        
        lblMessage.snp.removeConstraints()
        lblMessage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(imgPhoto.snp.right).offset(20)
            make.right.lessThanOrEqualToSuperview().inset(100)
            make.bottom.equalToSuperview().inset(20)
        }
        
        container.snp.removeConstraints()
        container.snp.makeConstraints { make in
            make.left.equalTo(lblMessage).offset(-10)
            make.right.equalTo(lblMessage).offset(10)
            make.top.equalTo(lblMessage).offset(-10)
            make.bottom.equalTo(lblMessage).offset(10)
           
        }
        
        container.backgroundColor = NeonMessengerConstants.connectionMessageBackgroundColor
        container.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner, .layerMaxXMinYCorner]
    }
    
}
#endif
