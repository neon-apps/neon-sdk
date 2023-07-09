//
//  NeonTestimonialCollectionView.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//

#if !os(xrOS)

import Foundation
import UIKit

@available(iOS 13.0, *)
protocol NeonTestimonialCollectionViewDelegate: AnyObject {
    func testimonialCollectionView(_ collectionView: NeonTestimonialCollectionView, destinationPage pageIndex: Int)
}


@available(iOS 13.0, *)
class NeonTestimonialCollectionView: NeonCollectionView<NeonTestimonial, NeonTestimonialCell> {

    public var testimonialCollectionViewDelegate: NeonTestimonialCollectionViewDelegate?
    private var nextPageIndex = 1
    
    public var intervalBetweenTestimonials = 5.0
    public var testimonialTextColor = UIColor.black
    public var testimonialbackgroundColor = UIColor.white
    public var testimonialbackgroundCornerRadious = 12
    
    
     convenience init() {
         NeonTestimonial.arrTestimonials = []
        self.init(
            objects: NeonTestimonial.arrTestimonials,
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

        Timer.scheduledTimer(timeInterval: intervalBetweenTestimonials, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc private func scrollToNextCell(){
        
        if nextPageIndex == NeonTestimonial.arrTestimonials.count{
            self.scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: true)
            testimonialCollectionViewDelegate?.testimonialCollectionView(self, destinationPage: 0)
            nextPageIndex = 1
        }else{
            self.scrollToItem(at: IndexPath(row: nextPageIndex, section: 0), at: .centeredHorizontally, animated: true)
            testimonialCollectionViewDelegate?.testimonialCollectionView(self, destinationPage: nextPageIndex)
            nextPageIndex += 1
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! NeonTestimonialCell
        cell.backgroundColor = testimonialbackgroundColor
        cell.authorLabel.textColor = testimonialTextColor
        cell.titleLabel.textColor = testimonialTextColor
        cell.testimonialLabel.textColor = testimonialTextColor
        cell.layer.cornerRadius = CGFloat(testimonialbackgroundCornerRadious)
        return cell
    }
    
    
}

#endif
