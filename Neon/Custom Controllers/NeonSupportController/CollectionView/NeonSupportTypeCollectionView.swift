//
//  NeonSupportCollectionView.swift
//  WatermarkRemover
//
//  Created by Tuna Öztürk on 21.10.2023.
//


import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
class NeonSupportTypeCollectionView: NeonCollectionView<NeonSupportType, NeonSupportTypeCell> {


    
     convenience init() {
        self.init(
            objects:  NeonSupportControllerConstants.arrSupportTypes,
            leftPadding: 20,
            rightPadding: 20,
            horizontalItemSpacing: 20,
            widthForItem: 0
        )
        updateUI()
    }
    
    private func updateUI(){
       showsHorizontalScrollIndicator = false
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
          }
    }
    

 
}


