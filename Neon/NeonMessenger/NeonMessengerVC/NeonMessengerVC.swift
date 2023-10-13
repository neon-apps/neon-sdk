//
//  InboxVC.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 11.09.2023.
//

import UIKit
import NeonSDK

open protocol NeonMessengerDelegate: AnyObject {
    func userProfileClicked(user : NeonMessengerUser)
    func messageSent(to user : NeonMessengerUser, message : Message)
    // Add other delegate methods as needed
}

@available(iOS 13.0, *)
open class NeonMessengerVC: UIViewController, NeonMessengerDelegate {

    fileprivate let chatsTableView = ChatsTableView()
    fileprivate let connectionsCollectionView = ConnectionsCollectionView()
    fileprivate var filteredConnections = NeonMessengerManager.arrConnections
    

   
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard NeonMessengerConstants.didColorsConfigured else {
            fatalError("NeonMessenger Colors should be configured before super.viewDidLoad() of the ViewController that inherit NeonMessengerVC. Use NeonMessenger.customizeColors to configure")
        }
        
        guard NeonMessengerConstants.didCurrentUserConfigured else {
            fatalError("NeonMessenger Current User should be configured before super.viewDidLoad() of the ViewController that inherit NeonMessengerVC. Use NeonMessenger.setCurrentUser to configure.")
        }
        
        guard NeonMessengerConstants.didContentsConfigured else {
            fatalError("NeonMessenger Contents should be configured before super.viewDidLoad() of the ViewController that inherit NeonMessengerVC. Use NeonMessenger.customizeContent method to configure.")
        }
        
        NeonChatVC.delegate = self
        
        createUI()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        NeonMessengerManager.fetchLastMessages(completion: { [self] in
            connectionsCollectionView.objects = NeonMessengerManager.arrConnections
            chatsTableView.objects = NeonMessengerManager.arrConnections.filter({$0.lastMessage != nil}).sorted(by: {$0.lastMessage!.date > $1.lastMessage!.date})
        })
    }
    func createUI(){
        
        view.backgroundColor = NeonMessengerConstants.secondaryBackgroundColor
        
        let titleLabel = UILabel()
        titleLabel.text = NeonMessengerConstants.messengerTitle
        titleLabel.textColor = NeonMessengerConstants.primaryTextColor
        titleLabel.font = Font.custom(size: 20, fontWeight: .SemiBold)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.centerX.equalToSuperview()
        }
        titleLabel.sizeToFit()
        
        let searchBar = NeonSearchBar()
        searchBar.borderColor = NeonMessengerConstants.searchfieldBorderColor
        searchBar.borderWidth = 3
        searchBar.cornerRadious = 15
        searchBar.iconSize = 20
        searchBar.icon = UIImage(named: "Search")
        searchBar.iconTintColor = NeonMessengerConstants.searchIconColor
        searchBar.placeholder = NeonMessengerConstants.searchfieldPlaceholder
        searchBar.textfield.textColor = NeonMessengerConstants.primaryTextColor
        searchBar.didSearched = { [self] searchText in
            
            if searchText != ""{
                filteredConnections = NeonMessengerManager.arrConnections.filter({$0.fullName.lowercased().contains(searchText.lowercased())})
            }else{
                filteredConnections = NeonMessengerManager.arrConnections
            }
          
            connectionsCollectionView.objects = filteredConnections
            chatsTableView.objects = filteredConnections.filter({$0.lastMessage != nil}).sorted(by: {$0.lastMessage!.date > $1.lastMessage!.date})
        }
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(20)
            make.height.equalTo(60)
        }
        
      
        connectionsCollectionView.didSelect = { user, indexPath in
            let destinationVC = NeonChatVC()
            destinationVC.choosenUser = user
            self.present(destinationVC: destinationVC, slideDirection: .right)
        }
        view.addSubview(connectionsCollectionView)
        connectionsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
       
        chatsTableView.didSelect = { user, indexPath in
            let destinationVC = NeonChatVC()
            destinationVC.choosenUser = user
            self.present(destinationVC: destinationVC, slideDirection: .right)
        }
        chatsTableView.trailingSwipeActions = [SwipeAction(title: "Delete", color: .systemRed, action: { [self] user, indexPath in
            deleteChat(user : user, indexPath: indexPath)
        })]
        view.addSubview(chatsTableView)
        chatsTableView.snp.makeConstraints { make in
            make.top.equalTo(connectionsCollectionView.snp.bottom).offset(15)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func deleteChat(user : NeonMessengerUser, indexPath : IndexPath){
        NeonMessengerManager.deleteChat(with: user)
        chatsTableView.beginUpdates()
        NeonMessengerManager.arrConnections.filter({$0.lastMessage != nil}).sorted(by: {$0.lastMessage!.date > $1.lastMessage!.date})[indexPath.row].lastMessage = nil
        chatsTableView.objects = NeonMessengerManager.arrConnections.filter({$0.lastMessage != nil}).sorted(by: {$0.lastMessage!.date > $1.lastMessage!.date})
        chatsTableView.deleteRows(at: [indexPath], with: .left)
        chatsTableView.endUpdates()
    }

    open func userProfileClicked(user: NeonMessengerUser) {
        
    }
    
    open func messageSent(to user: NeonMessengerUser, message: Message) {
        
    }
    

}

