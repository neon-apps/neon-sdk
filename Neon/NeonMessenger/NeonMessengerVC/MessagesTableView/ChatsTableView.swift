//
//  ChatsTableView.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 11.09.2023.
//

#if !os(xrOS)

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class ChatsTableView: NeonTableView<NeonMessengerUser, ChatCell> {

    
     convenience init() {
        
         self.init(objects : [NeonMessengerUser](), heightForRows: 80, style: .grouped)
        updateUI()
  
    }
    
    private func updateUI(){
       showsHorizontalScrollIndicator = false
        backgroundColor = NeonMessengerConstants.secondaryBackgroundColor
      
    }
 
}

#endif
