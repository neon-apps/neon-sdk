//
//  NeonTestemonialCollectionView.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//

#if !os(xrOS)

import Foundation
import UIKit

@available(iOS 13.0, *)
protocol NeonTestemonialCollectionViewDelegate: AnyObject {
    func testemonialCollectionView(_ collectionView: NeonTestemonialCollectionView, destinationPage pageIndex: Int)
}


@available(iOS 13.0, *)
class NeonTestemonialCollectionView: NeonCollectionView<NeonTestemonial, NeonTestemonialCell> {

    public var testemonialCollectionViewDelegate: NeonTestemonialCollectionViewDelegate?
    private var nextPageIndex = 1
    
    public var intervalBetweenTestemonials = 5.0
    public var testemonialTextColor = UIColor.black
    public var testemonialbackgroundColor = UIColor.white
    public var testemonialbackgroundCornerRadious = 12
    
    
     convenience init() {
         NeonTestemonial.arrTestemonials = []
        self.init(
            objects: NeonTestemonial.arrTestemonials,
            leftPadding: 25,
            rightPadding: 25,
            horizontalItemSpacing: 10,
            widthForItem: UIScreen.main.bounds.width - 50
        )
        self.didSelect = didSelect
        startAnimation()
        updateUI()
    }
    
    private func updateUI(){
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
      
    }
    private func startAnimation(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.scrollToNextCell()
        })

        Timer.scheduledTimer(timeInterval: intervalBetweenTestemonials, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc private func scrollToNextCell(){
        
        if nextPageIndex == NeonTestemonial.arrTestemonials.count{
            self.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
            testemonialCollectionViewDelegate?.testemonialCollectionView(self, destinationPage: 0)
            nextPageIndex = 1
        }else{
            self.scrollToItem(at: IndexPath(row: nextPageIndex, section: 0), at: .centeredHorizontally, animated: true)
            testemonialCollectionViewDelegate?.testemonialCollectionView(self, destinationPage: nextPageIndex)
            nextPageIndex += 1
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! NeonTestemonialCell
        cell.backgroundColor = testemonialbackgroundColor
        cell.authorLabel.textColor = testemonialTextColor
        cell.titleLabel.textColor = testemonialTextColor
        cell.testemonialLabel.textColor = testemonialTextColor
        cell.layer.cornerRadius = CGFloat(testemonialbackgroundCornerRadious)
        return cell
    }
    
    
}

#endif
