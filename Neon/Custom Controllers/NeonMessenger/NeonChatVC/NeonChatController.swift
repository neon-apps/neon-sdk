//
//  ChatVC.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 11.09.2023.
//

import UIKit
import NeonSDK


@available(iOS 13.0, *)
class NeonChatController: UIViewController {

    let messagesTableView = MessagesTableView()
    var choosenUser = NeonMessengerUser()
    var arrMessages = [Message]()
    
    static var delegate : NeonMessengerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        createUI()
        fetchChat()
        listenChat()
        markAsRead()
    }
    
    func createUI(){
        
        view.backgroundColor = NeonMessengerConstants.primaryBackgroundColor
        
        let viewHeader = UIView()
        view.addSubview(viewHeader)
        viewHeader.isUserInteractionEnabled = true
        viewHeader.backgroundColor = NeonMessengerConstants.secondaryBackgroundColor
        viewHeader.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(70)
        }
        
        let imgBack = UIButton()
        imgBack.setBackgroundImage(UIImage(systemName: "chevron.backward"), for: .normal)
        imgBack.imageView?.contentMode = .scaleAspectFit
        imgBack.tintColor = NeonMessengerConstants.backButtonColor
        viewHeader.addSubview(imgBack)
        imgBack.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.height.equalTo(30)
            make.width.equalTo(20)
            make.bottom.equalToSuperview().inset(30)
        }
        imgBack.addTarget(self, action: #selector(imgBackClicked), for: .touchUpInside)
    
        
        let imgUser = UIImageView()
        imgUser.setImage(urlString: choosenUser.photoURL)
        imgUser.layer.cornerRadius = 25
        imgUser.contentMode = .scaleAspectFill
        imgUser.layer.masksToBounds = true
        viewHeader.addSubview(imgUser)
        imgUser.snp.makeConstraints { make in
            make.left.equalTo(imgBack.snp.right).offset(20)
            make.width.height.equalTo(50)
            make.centerY.equalTo(imgBack.snp.centerY)
        }
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(userProfileClicked))
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(recognizer)
        
        let lblUserName = UILabel()
        lblUserName.text = choosenUser.fullName
        lblUserName.font = Font.custom(size: 17, fontWeight: .SemiBold)
        viewHeader.addSubview(lblUserName)
        lblUserName.snp.makeConstraints { make in
            make.left.equalTo(imgUser.snp.right).offset(20)
            make.centerY.equalTo(imgBack.snp.centerY)
        }
        lblUserName.sizeToFit()
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(userProfileClicked))
        lblUserName.isUserInteractionEnabled = true
        lblUserName.addGestureRecognizer(recognizer2)
        
        
       
        messagesTableView.objects = arrMessages
        messagesTableView.shouldReloadWhenObjectsSet = false
        view.addSubview(messagesTableView)
        messagesTableView.snp.makeConstraints { make in
            make.top.equalTo(viewHeader.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        let chatToolbar = NeonChatToolBar()
        chatToolbar.borderColor = NeonMessengerConstants.inputFieldBorderColor
        chatToolbar.cornerRadious = 22.5
        chatToolbar.backgroundColor = NeonMessengerConstants.secondaryBackgroundColor
        chatToolbar.icon = UIImage(systemName: "arrow.up.circle.fill")
        chatToolbar.placeholder = NeonMessengerConstants.inputFieldPlaceholder
        chatToolbar.sendMessageClicked = { [self] message in
            NeonChatController.delegate?.messageSent(to: choosenUser, message: Message(content: message, sender: NeonMessengerManager.currentUser, date: Date()))
            NeonMessengerManager.addMessage(connection: choosenUser, content: message, sender: NeonMessengerManager.currentUser, chat: &self.arrMessages)
            updateTable()
        }
        view.addSubview(chatToolbar)
        chatToolbar.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(chatToolbar.textview.snp.height).offset(10)
        }
    
    }
    
    func fetchChat(){
        
        NeonMessengerManager.fetchChat(connection : choosenUser, completion: { messages in
            self.arrMessages = messages
            self.updateTable()
        })
    }
    
    func listenChat(){
        
        NeonMessengerManager.listenChat(connection: choosenUser) { newMessage in
            self.arrMessages.append(newMessage)
            self.updateTable()
        }
    }
    
    func updateTable(){
        self.arrMessages.sortByDate()
        self.messagesTableView.objects = self.arrMessages
        self.messagesTableView.reloadData()
        guard    !arrMessages.isEmpty else {return}
        self.messagesTableView.scrollToRow(at: IndexPath(row: self.arrMessages.count - 1, section: 0), at: .bottom, animated: true)
    }
    @objc func imgBackClicked(){
        FirestoreManager.removeActiveListeners()
        NeonMessengerManager.markChatAsRead(with: choosenUser)
        dismiss(animated: true)
    }
    
    @objc func userProfileClicked(){
        NeonChatController.delegate?.userProfileClicked(user: choosenUser)
    }
    
    @objc func markAsRead(){
        NeonMessengerManager.markChatAsRead(with: choosenUser)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
