//
//  MessagesTableView.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 12.09.2023.
//


#if !os(xrOS)

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class MessagesTableView: NeonTableView<Message, MessageCell> {

     convenience init() {
         
         self.init(objects : [Message](), heightForRows: 80, style: .grouped)
        updateUI()
         self.rowHeight = UITableView.automaticDimension
         self.estimatedRowHeight = 80
         self.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 70, right: 0)
         self.backgroundColor = NeonMessengerConstants.primaryBackgroundColor
  
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    private func updateUI(){
       showsHorizontalScrollIndicator = false
    }
 
}

#endif
