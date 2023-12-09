//
//  NeonSupportController.swift
//  WatermarkRemover
//
//  Created by Tuna Öztürk on 21.10.2023.
//


import Foundation
import UIKit
import NeonSDK
@available(iOS 13.0, *)
open class NeonSupportController: UIViewController {
    
    let messageTextView = NeonTextView()
    let btnSend = UIButton()
    let viewDetails = UIView()
    let lblAddYourDetails = UILabel()
    let supportTypeCollectionView = NeonSupportTypeCollectionView()
    let titleLabel = UILabel()
    let toggleContact = UISwitch()
    let textfieldName = NeonTextField()
    let textfieldEmail = NeonTextField()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        checkControllerType()
        checkCustomAlertManager()
        getContactDetailsFromCache()
    }

    private func setupUI() {
        // Header View
        
        view.backgroundColor = NeonSupportControllerConstants.backgroundColor
   
        
        
      
        titleLabel.text =  NeonSupportControllerConstants.choosenControllerType.rawValue
        titleLabel.textColor = NeonSupportControllerConstants.textColor
        titleLabel.font = Font.custom(size: 18, fontWeight: .SemiBold)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        
        // Back Button
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = NeonSupportControllerConstants.textColor
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.leading.equalToSuperview().offset(16)
            make.height.width.equalTo(50)
        }
        
    
        view.addSubview(supportTypeCollectionView)
        supportTypeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        supportTypeCollectionView.backgroundColor = .clear
        supportTypeCollectionView.didSelect = { [self] supportType, indexPath in
            NeonSupportControllerConstants.choosenSupportType = supportType
            supportTypeSelected()

        }

        
        
        view.addSubview(btnSend)
        btnSend.backgroundColor = NeonSupportControllerConstants.mainColor
        btnSend.setTitle(NeonSupportControllerConstants.choosenSupportType.ctaButtonTitle, for: .normal)
        btnSend.layer.cornerRadius = 10
        btnSend.setTitleColor(NeonSupportControllerConstants.buttonTextColor, for: .normal)
        btnSend.layer.masksToBounds = true
        btnSend.addTarget(self, action: #selector(btnSendClicked), for: .touchUpInside)
        btnSend.titleLabel?.font = Font.custom(size: 18, fontWeight: .SemiBold)
        btnSend.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
        
        view.addSubview(viewDetails)
        viewDetails.isHidden = true
      
        textfieldEmail.backgroundColor = NeonSupportControllerConstants.containerColor
        viewDetails.addSubview(textfieldEmail)
        textfieldEmail.setCustomPlaceholder("johndoe@gmail.com", color: NeonSupportControllerConstants.placeholderColor)
        textfieldEmail.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textfieldEmail.autocapitalizationType = .none
        textfieldEmail.autocorrectionType = .no
        textfieldEmail.textColor = NeonSupportControllerConstants.textColor
        textfieldEmail.font = Font.custom(size: 13, fontWeight: .Medium)
        textfieldEmail.layer.cornerRadius = 10
        textfieldEmail.layer.masksToBounds = true
        textfieldEmail.snp.makeConstraints { make in
            make.bottom.equalTo(btnSend.snp.top).offset(-50)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        let lblEmail = UILabel()
        viewDetails.addSubview(lblEmail)
        lblEmail.textColor = NeonSupportControllerConstants.textColor
        lblEmail.text = "E-Mail"
        lblEmail.font = Font.custom(size: 15, fontWeight: .SemiBold)
        lblEmail.snp.makeConstraints { make in
            make.bottom.equalTo(textfieldEmail.snp.top).offset(-10)
            make.left.equalTo(textfieldEmail.snp.left).offset(3)
        }
        lblEmail.sizeToFit()
        
      
        textfieldName.backgroundColor = NeonSupportControllerConstants.containerColor
        textfieldName.textColor = NeonSupportControllerConstants.textColor
        viewDetails.addSubview(textfieldName)
        textfieldName.setCustomPlaceholder("John Doe", color: NeonSupportControllerConstants.placeholderColor)
        textfieldName.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        textfieldName.font = Font.custom(size: 13, fontWeight: .Medium)
        textfieldName.layer.cornerRadius = 10
        textfieldName.layer.masksToBounds = true
        textfieldName.snp.makeConstraints { make in
            make.bottom.equalTo(lblEmail.snp.top).offset(-20)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        let lblName = UILabel()
        viewDetails.addSubview(lblName)
        lblName.textColor = NeonSupportControllerConstants.textColor
        lblName.text = "Name"
        lblName.font = Font.custom(size: 15, fontWeight: .SemiBold)
        lblName.snp.makeConstraints { make in
            make.bottom.equalTo(textfieldName.snp.top).offset(-10)
            make.left.equalTo(textfieldName.snp.left).offset(3)
        }
        lblName.sizeToFit()
        
        
        viewDetails.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(lblName.snp.top)
            make.bottom.equalTo(textfieldEmail.snp.bottom)
        }
       
        view.addSubview(lblAddYourDetails)
        lblAddYourDetails.textColor = NeonSupportControllerConstants.textColor
        lblAddYourDetails.text = "Add your contact details"
        lblAddYourDetails.font = Font.custom(size: 18, fontWeight: .SemiBold)
        lblAddYourDetails.snp.makeConstraints { make in
            make.bottom.equalTo(lblName.snp.top).offset(-30)
            make.left.equalTo(textfieldName.snp.left).offset(3)
        }
        lblAddYourDetails.sizeToFit()
        
        
        toggleContact.onTintColor = NeonSupportControllerConstants.mainColor
        toggleContact.addTarget(self, action: #selector(toggleChanged(_:)), for: .valueChanged)
        view.addSubview(toggleContact)
        toggleContact.snp.makeConstraints { make in
            make.centerY.equalTo(lblAddYourDetails)
            make.right.equalTo(textfieldName.snp.right).offset(-3)
        }
        
        view.addSubview(messageTextView)
        messageTextView.backgroundColor = NeonSupportControllerConstants.containerColor
        messageTextView.textColor = NeonSupportControllerConstants.textColor
        messageTextView.layer.cornerRadius = 10
        messageTextView.layer.masksToBounds = true
        messageTextView.placeholder = NSString(utf8String: NeonSupportControllerConstants.choosenSupportType.placeholder)
        messageTextView.placeholderColor = NeonSupportControllerConstants.placeholderColor
        messageTextView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        messageTextView.font = Font.custom(size: 13, fontWeight: .Medium)
        messageTextView.snp.makeConstraints { make in
            make.top.equalTo(supportTypeCollectionView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(20)
            make.bottom.equalTo(lblAddYourDetails.snp.top).offset(-20)
        }
    }
    
    @objc func btnSendClicked(){
        
        if !isConnectedToNetwork(){
           return
        }
        
        if toggleContact.isOn{
            if areFieldsValid(){
                showAlert()
                cacheContactDetails()
                sendMessageToDatabase()
            }
        }else{
            if isMessageValid() {
                showSendingWithoutContactDetailsAlert()
            }
        }
        
    }
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    
    @objc private func toggleChanged(_ toggle : UISwitch) {
        viewDetails.isHidden = !toggle.isOn
    }
    
    
    func showAlert(){
        NeonAlertManager.custom.present(
            viewController: self,
            title: NeonSupportControllerConstants.choosenSupportType.successMessageTitle,
            message: NeonSupportControllerConstants.choosenSupportType.successMessage,
            icon: NeonSymbols.checkmark_seal,
            iconTintColor: NeonSupportControllerConstants.mainColor,
            iconSize: CGSize(width: 50, height: 50),
            verticalPadding: 20,
            buttons: [
                CustomAlertButton(title: "Okay!",
                                  buttonType: .background,
                                  overrideTextColor: NeonSupportControllerConstants.buttonTextColor,
                                  completion: {
                                      self.dismiss(animated: true)
                                  }),
                CustomAlertButton(title: "Send Another",
                                  buttonType: .text,
                                  overrideTextColor: NeonSupportControllerConstants.textButtonColor,
                                  completion: {
                                      self.messageTextView.text = ""
                                  })
            ])
    }
    func checkControllerType(){
        if NeonSupportControllerConstants.choosenControllerType != .standard{
            NeonSupportControllerConstants.choosenSupportType = NeonSupportControllerConstants.arrSupportTypes.first(where: {$0.controllerType == NeonSupportControllerConstants.choosenControllerType})!
            supportTypeSelected()
            supportTypeCollectionView.isHidden = true
            messageTextView.snp.remakeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(40)
                make.left.right.equalToSuperview().inset(20)
                make.bottom.equalTo(lblAddYourDetails.snp.top).offset(-20)
            }
        }
    }
    func supportTypeSelected(){
        supportTypeCollectionView.reloadData()
        messageTextView.placeholder = NSString(utf8String: NeonSupportControllerConstants.choosenSupportType.placeholder)
        btnSend.setTitle(NeonSupportControllerConstants.choosenSupportType.ctaButtonTitle, for: .normal)
    }
    
    func checkCustomAlertManager(){
        if !NeonAlertManager.custom.isConfigured{
            fatalError("You have to configure the CustomAlertManager before using NeonSupportController. Use NeonAlertManager.custom.configure method in your AppDelegate's didFinishLaunchingWithOptions.")

        }
    }
    
    func areFieldsValid() -> Bool {
        // Check if the message text is empty
        if !isMessageValid() {
            return false
        }
        
        // If the "Add Contact Details" switch is on, validate name and email
        if toggleContact.isOn {
            if textfieldName.text == "" {
                NeonAlertManager.custom.present(
                    viewController: self,
                    title: "Oops!",
                    message: "Your name can't be blank. Please enter your name or turn off the contact details switch.",
                    icon: NeonSymbols.info_circle,
                    iconTintColor: NeonSupportControllerConstants.mainColor,
                    iconSize: CGSize(width: 50, height: 50),
                    verticalPadding: 20,
                    buttons: [
                        CustomAlertButton(title: "Okay",
                                          buttonType: .background,
                                         overrideTextColor: NeonSupportControllerConstants.buttonTextColor)
                    ])
                return false
            }
            
            if textfieldEmail.text == "" {
                NeonAlertManager.custom.present(
                    viewController: self,
                    title: "Oops!",
                    message: "Your email can't be blank. Please enter your email or turn off the contact details switch.",
                    icon: NeonSymbols.info_circle,
                    iconTintColor: NeonSupportControllerConstants.mainColor,
                    iconSize: CGSize(width: 50, height: 50),
                    verticalPadding: 20,
                    buttons: [
                        CustomAlertButton(title: "Okay", 
                                          buttonType: .background,
                                         overrideTextColor: NeonSupportControllerConstants.buttonTextColor)
                    ])
                return false
            }
            
            if !NeonValidationManager.isValid(email: textfieldEmail.text!) {
                NeonAlertManager.custom.present(
                    viewController: self,
                    title: "Oops!",
                    message: "Uh-oh! The email you entered seems invalid. Please check and try again.",
                    icon: NeonSymbols.info_circle,
                    iconTintColor: NeonSupportControllerConstants.mainColor,
                    iconSize: CGSize(width: 50, height: 50),
                    verticalPadding: 20,
                    buttons: [
                        CustomAlertButton(title: "Okay",
                                          buttonType: .background,
                                         overrideTextColor: NeonSupportControllerConstants.buttonTextColor)
                    ])
                return false
            }
            
            // All fields are valid
            return true
        } else {
            // No need to validate contact details when the switch is off
            return true
        }
    }
    
    func isMessageValid() -> Bool{
        if messageTextView.text == "" {
            NeonAlertManager.custom.present(
                viewController: self,
                title: "Oops!",
                message: "Hold on! You can't send an empty message.",
                icon: NeonSymbols.info_circle,
                iconTintColor: NeonSupportControllerConstants.mainColor,
                iconSize: CGSize(width: 50, height: 50),
                verticalPadding: 20,
                buttons: [
                    CustomAlertButton(title: "Okay",
                                      buttonType: .background,
                                     overrideTextColor: NeonSupportControllerConstants.buttonTextColor)
                ])
            return false
        }
        return true
    }
    func sendMessageToDatabase(){
        FirestoreManager.setDocument(path: [
            .collection(name: "Support Form Responses"),
            .document(name: "Form Types"),
            .collection(name: "\(NeonSupportControllerConstants.choosenSupportType.title)"),
            .document(name: "\(UUID().uuidString)")], fields: [
                "Message" : messageTextView.text!,
                "E-mail" : textfieldEmail.text!,
                "Name" : textfieldName.text!,
                "Date" : Date(),
                "Device" : NeonDeviceManager.currentDeviceModel.stringValue
        ])
        
        FirestoreManager.setDocument(path: [
            .collection(name: "Support Form Responses"),
            .document(name: "All Responses"),
            .collection(name: "\(NeonSupportControllerConstants.choosenSupportType.title)"),
            .document(name: "\(UUID().uuidString)")], fields: [
                "Form Type" : NeonSupportControllerConstants.choosenSupportType.title,
                "Message" : messageTextView.text!,
                "E-mail" : textfieldEmail.text!,
                "Name" : textfieldName.text!,
                "Date" : Date(),
                "Device" : NeonDeviceManager.currentDeviceModel.stringValue
        ])
       
    }

    
    func showSendingWithoutContactDetailsAlert(){
        NeonAlertManager.custom.present(
            viewController: self,
            title: "Proceed Without Contact Details?",
            message: "If you submit this form without contact details, we won't be able to reach out to you regarding your request. Are you sure you want to continue?",
            icon: NeonSymbols.checkmark_seal,
            iconTintColor: NeonSupportControllerConstants.mainColor,
            iconSize: CGSize(width: 50, height: 50),
            verticalPadding: 20,
            buttons: [
                CustomAlertButton(title: "Add My Contact Details",
                                  buttonType: .background,
                                  overrideTextColor: NeonSupportControllerConstants.buttonTextColor,
                                  completion: { [self] in
                                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [self] in
                                          toggleContact.setOn(true, animated: true)
                                          toggleChanged(toggleContact)
                                      })
                                  }),
                CustomAlertButton(title: "Send Anyway",
                                  buttonType: .text,
                                  overrideTextColor: NeonSupportControllerConstants.textButtonColor,
                                  completion: { [self] in
                                      DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [self] in
                                          if areFieldsValid(){
                                              cacheContactDetails()
                                              showAlert()
                                              sendMessageToDatabase()
                                          }
                                      })
                                  })
            ])
    }

    
    func isConnectedToNetwork() -> Bool{
        if !NeonNetworkManager.isConnected() {
            NeonAlertManager.custom.present(
                viewController: self,
                title: "Network Connection Required",
                message: "Oops! You don't have an active network connection. Please check your internet settings and try again.",
                icon: NeonSymbols.info_circle,
                iconTintColor: NeonSupportControllerConstants.mainColor,
                iconSize: CGSize(width: 50, height: 50),
                verticalPadding: 20,
                buttons: [
                    CustomAlertButton(title: "Okay",
                                      buttonType: .background,
                                     overrideTextColor: NeonSupportControllerConstants.buttonTextColor)
                ])
            return false
        }
        return true
    }
    
    func cacheContactDetails(){
        UserDefaults.standard.set(textfieldEmail.text!, forKey: "NeonSupportController-ContactDetails-Email")
        UserDefaults.standard.set(textfieldName.text!, forKey: "NeonSupportController-ContactDetails-Name")
        UserDefaults.standard.set(toggleContact.isOn, forKey: "NeonSupportController-ContactDetails-isOn")
    }
    
    func getContactDetailsFromCache(){
        textfieldEmail.text = UserDefaults.standard.string(forKey: "NeonSupportController-ContactDetails-Email")
        textfieldName.text = UserDefaults.standard.string(forKey: "NeonSupportController-ContactDetails-Name")
        toggleContact.isOn = UserDefaults.standard.bool(forKey: "NeonSupportController-ContactDetails-isOn")
        toggleChanged(toggleContact)
    }
    
    
}



