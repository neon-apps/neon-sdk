//
//  ConnectionsCollectionView.swift
//  NeonSDKChatModule
//
//  Created by Tuna Öztürk on 11.09.2023.
//

#if !os(xrOS)

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class ConnectionsCollectionView: NeonCollectionView<NeonMessengerUser, ConnectionCell> {


    
     convenience init() {
        self.init(
            objects:  [NeonMessengerUser](),
            leftPadding: 20,
            rightPadding: 20,
            horizontalItemSpacing: 20,
            widthForItem: 70
        )
        updateUI()
    }
    
    private func updateUI(){
       showsHorizontalScrollIndicator = false
        backgroundColor = NeonMessengerConstants.secondaryBackgroundColor
    }
 
}

#endif
