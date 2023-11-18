//
//  CustomView.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import UIKit
import Foundation
import NeonSDK

@available(iOS 13.0, *)
protocol NeonLongOnboardingPageOptionViewDelegate: AnyObject {
    func optionDidSelect(_ option: NeonLongOnboardingPageOptionView)
    func optionDidDeselect(_ option: NeonLongOnboardingPageOptionView)
}

@available(iOS 13.0, *)
class NeonLongOnboardingPageOptionView: UIView {
    
    weak var delegate: NeonLongOnboardingPageOptionViewDelegate?

    
    let titleLabel = UILabel()
    let emojiLabel = UILabel()
    var isSelected = false
    var selectedIcon = UIImageView()
    var id = UUID().uuidString
    var isMultipleSelectionEnabled = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupGesture()
        
    }

    private func setupViews() {
        
        backgroundColor = NeonLongOnboardingConstants.optionBackgroundColor
        layer.borderColor = NeonLongOnboardingConstants.optionBorderColor.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 20
        
        emojiLabel.font = Font.custom(size: 30, fontWeight: .Medium)
        addSubview(emojiLabel)
        emojiLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
     
        selectedIcon.contentMode = .scaleAspectFit
        selectedIcon.tintColor = NeonLongOnboardingConstants.selectedOptionBorderColor
        selectedIcon.isHidden = true
        selectedIcon.image = NeonSymbols.checkmark_seal_fill
        addSubview(selectedIcon)
        selectedIcon.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.right).inset(40)
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        
        titleLabel.textColor = NeonLongOnboardingConstants.textColor
        titleLabel.font = Font.custom(size: 16, fontWeight: .Medium)
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(emojiLabel.snp.right).offset(20)
            make.right.equalTo(selectedIcon.snp.left).offset(-20)
            make.top.equalToSuperview().offset(20)
        }
        titleLabel.sizeToFit()
    }
    
    func setupGesture(){
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(optionSelected))
        isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGesture)
    }

    @objc func optionSelected(){
        
        if !isMultipleSelectionEnabled{
            setSelected()
            return
        }
        
        isSelected.toggle()
    
        if isSelected{
            setSelected()
        }else{
            setDeselected()
        }
      
    }
    
    func setSelected(){
        isSelected = true
        animate(type: .bounce)
        
        selectedIcon.animate(type: .scaleIn, duration: 0.4)
        selectedIcon.isHidden = false
        delegate?.optionDidSelect(self)
        backgroundColor = NeonLongOnboardingConstants.selectedOptionBackgroundColor
        layer.borderColor = NeonLongOnboardingConstants.selectedOptionBorderColor.cgColor
    }
    
    func setDeselected(){
        isSelected = false
        selectedIcon.isHidden = true
        delegate?.optionDidDeselect(self)
        backgroundColor = NeonLongOnboardingConstants.optionBackgroundColor
        layer.borderColor = NeonLongOnboardingConstants.optionBorderColor.cgColor
    }
    // MARK: - Public Methods
    func configure(title: String, emoji: String) {
        titleLabel.text = title.changeUsername()
        emojiLabel.text = emoji
    }
}
