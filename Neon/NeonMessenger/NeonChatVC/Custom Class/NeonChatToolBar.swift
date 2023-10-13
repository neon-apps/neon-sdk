//
//  Chattextview.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 12.09.2023.
//

#if !os(xrOS)
import Foundation
import UIKit
import NeonSDK

public class NeonChatToolBar : UIView, UITextViewDelegate {
    
    var btnSend = UIButton()
    let textview = NeonTextView()
    
    var cornerRadious : CGFloat = 15 {
        didSet{
            self.layer.cornerRadius = cornerRadious
        }
    }
    
    var borderColor : UIColor = .clear {
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    var borderWidth : CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    
    var sendMessageClicked : ((_ message : String) -> ())?
    
    var placeholder : String = "Type here..."{
        didSet{
            textview.placeholder = NSString(utf8String: placeholder)
        }
    }
    
    var icon : UIImage? = nil{
        didSet{
            btnSend.setBackgroundImage(icon, for: .normal)
        }
    }
    
    public init(){
        super.init(frame: .zero)

        setupView()
        textview.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
       
        addSubview(btnSend)
        btnSend.contentMode = .scaleAspectFit
        btnSend.tintColor = NeonMessengerConstants.sendButtonColor
        btnSend.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(2.5)
            make.right.equalToSuperview().inset(5)
            make.height.width.equalTo(40)
        }
        btnSend.addTarget(self, action: #selector(btnSendClicked), for: .touchUpInside)
       
       
        addSubview(textview)
        textview.backgroundColor = .clear
        textview.textColor = NeonMessengerConstants.inputFieldTextColor
        textview.font = Font.custom(size: 13, fontWeight: .Regular)
        textview.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(btnSend.snp.left).offset(-16)
            make.left.equalToSuperview().offset(16)
            make.height.equalTo(35)
        }
 
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        let fixedWidth = textView.frame.size.width
        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: .greatestFiniteMagnitude))
        textview.snp.updateConstraints() { make in
            make.height.equalTo(min(150, max(35,newSize.height)))
        }
    }
    
    
    @objc func btnSendClicked(){
        
        
        
        guard textview.text != "" else {
            return
        }
        
        if let sendMessageClicked{
            sendMessageClicked(textview.text)
            textview.text = ""
            textViewDidChange(textview)
        }
        
       
    }
 
    
}
#endif
