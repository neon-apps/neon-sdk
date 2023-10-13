//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 13.10.2023.
//

#if !os(xrOS)
import Foundation
import UIKit

public class NeonSearchBar : UIView{
    
    var imgIcon = UIImageView()
    let textfield = NeonTextField()
    
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
    
    var icon : UIImage? = nil{
        didSet{
            imgIcon.image = icon?.withRenderingMode(.alwaysTemplate)
        }
    }
    
    var iconTintColor : UIColor? = nil{
        didSet{
            imgIcon.tintColor = iconTintColor
        }
    }
    
   
    var iconSize : CGFloat = 20{
        didSet{
            imgIcon.snp.updateConstraints { make in
                make.height.width.equalTo(iconSize)
            }
        }
    }
    
    var placeholder : String = "Search Contacts"{
        didSet{
            textfield.placeholder = placeholder
        }
    }
    
    var didSearched: ((String) -> Void)?
    
    public init(){
        super.init(frame: .zero)

        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
       
        addSubview(imgIcon)
        imgIcon.contentMode = .scaleAspectFit
        imgIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.height.width.equalTo(iconSize)
        }
       
       
        textfield.placeholder = placeholder
        textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        addSubview(textfield)
        textfield.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(imgIcon.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
          if let text = textField.text {
              didSearched?(text)
          }
      }
    
}
#endif
