//
//  NeonSlideCollectionView.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//

#if !os(xrOS)

import Foundation
import UIKit
import NeonSDK

@available(iOS 13.0, *)
protocol NeonSlideCollectionViewDelegate: AnyObject {
    func slideCollectionView(_ collectionView: NeonSlideCollectionView, destinationPage pageIndex: Int)
}


@available(iOS 13.0, *)
class NeonSlideCollectionView: NeonCollectionView<NeonSlideItem, NeonSlideCell> {

    public var slideCollectionViewDelegate: NeonSlideCollectionViewDelegate?
    private var nextPageIndex = 1
    
    public var intervalBetweenSlides = 5.0
    public var textColor = UIColor.black
    public var showBeforeAfterBadges = false
    public var slideBackgroundColor = UIColor.white
    public var slideBackgroundCornerRadious = 12
    public var mainColor = UIColor.white
    public var beforeAfterBadgesTextColor = UIColor.black
     convenience init() {
         NeonSlideItem.arrSlides = []
        self.init(
            objects: NeonSlideItem.arrSlides,
            leftPadding: 0,
            rightPadding: 0,
            horizontalItemSpacing: 0,
            widthForItem: 0
        )
        self.didSelect = didSelect
        startAnimation()
        updateUI()
    }
    
    private func updateUI(){
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        isScrollEnabled = false
        isUserInteractionEnabled = false
    }
    private func startAnimation(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.scrollToNextCell()
        })

        Timer.scheduledTimer(timeInterval: intervalBetweenSlides, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc private func scrollToNextCell(){
        
        if nextPageIndex == NeonSlideItem.arrSlides.count{
            self.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
            slideCollectionViewDelegate?.slideCollectionView(self, destinationPage: 0)
            nextPageIndex = 1
        }else{
            self.scrollToItem(at: IndexPath(row: nextPageIndex, section: 0), at: .centeredHorizontally, animated: true)
            slideCollectionViewDelegate?.slideCollectionView(self, destinationPage: nextPageIndex)
            nextPageIndex += 1
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! NeonSlideCell
        cell.backgroundContentView.backgroundColor = slideBackgroundColor
        cell.titleLabel.textColor = textColor
        cell.subtitleLabel.textColor = textColor
        cell.backgroundContentView.layer.cornerRadius = CGFloat(slideBackgroundCornerRadious)
        cell.backgroundContentView.layer.masksToBounds =  true
        cell.backgroundColor = .clear
        cell.lblAfterBadge.isHidden = !showBeforeAfterBadges
        cell.lblBeforeBadge.isHidden = !showBeforeAfterBadges
        cell.lblAfterBadge.backgroundColor = mainColor
        cell.lblBeforeBadge.backgroundColor = mainColor
        cell.lblAfterBadge.textColor = beforeAfterBadgesTextColor
        cell.lblBeforeBadge.textColor = beforeAfterBadgesTextColor
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
    
        let collectionViewHeight = collectionView.bounds.height
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)

    }
}

#endif
