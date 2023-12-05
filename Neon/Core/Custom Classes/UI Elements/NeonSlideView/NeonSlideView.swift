//
//  NeonSlideView.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//

#if !os(xrOS)
import Foundation
import UIKit
import NeonSDK


@available(iOS 13.0, *)
public class NeonSlideView: UIView, NeonSlideCollectionViewDelegate {
    
    let slideCollectionView = NeonSlideCollectionView()
    var pageControl = NeonBasePageControl()

    public var intervalBetweenSlides = 5.0{
        didSet{
            slideCollectionView.intervalBetweenSlides = intervalBetweenSlides
        }
    }
    
    public var showBeforeAfterBadges = false{
        didSet{
            slideCollectionView.showBeforeAfterBadges = showBeforeAfterBadges
        }
    }
    
    public var textColor = UIColor.black{
        didSet{
            slideCollectionView.textColor = textColor
        }
    }
    public var beforeAfterBadgesTextColor = UIColor.black{
        didSet{
            slideCollectionView.beforeAfterBadgesTextColor = beforeAfterBadgesTextColor
        }
    }
    public var slideBackgroundColor = UIColor.white{
        didSet{
            slideCollectionView.slideBackgroundColor = slideBackgroundColor
        }
    }
    public var slideBackgroundCornerRadious = 12{
        didSet{
            slideCollectionView.slideBackgroundCornerRadious = slideBackgroundCornerRadious
        }
    }
    
    public var mainColor = UIColor.black{
        didSet{
            slideCollectionView.mainColor = mainColor
            pageControl.currentPageTintColor = mainColor
        }
    }
    
    public var pageTintColor = UIColor.black{
        didSet{
            pageControl.tintColor = pageTintColor
        }
    }
    
    public var pageControlType = PageControlType.V1{
        didSet{
            switch pageControlType {
            case .V1:
                pageControl = NeonPageControlV1()
                break
            case .V2:
                pageControl = NeonPageControlV2()
                break
            case .V3:
                pageControl = NeonPageControlV3()
                break
            case .V4:
                pageControl = NeonPageControlV4()
            case .V5:
                pageControl = NeonPageControlV5()
            case .V6:
                pageControl = NeonPageControlV6()
            case .V7:
                pageControl = NeonPageControlV7()
            case .V8:
                pageControl = NeonPageControlV8()
            }
            configurePageControl()
        }
    }
    
    public enum PageControlType{
        case V1
        case V2
        case V3
        case V4
        case V5
        case V6
        case V7
        case V8
    }
    
    public init() {
        super.init(frame: .zero)

        
      
        addSubview(slideCollectionView)
        slideCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
        slideCollectionView.slideCollectionViewDelegate = self
     
   
    }
    
    func configurePageControl(){
        pageControl.removeFromSuperview()
        addSubview(pageControl)
        pageControl.radius = 3
        pageControl.currentPageTintColor = mainColor
        pageControl.tintColor = pageTintColor
        pageControl.padding = 6
        pageControl.numberOfPages = NeonSlideItem.arrSlides.count
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(slideCollectionView.snp.bottom).offset(10)
            make.bottom.equalTo(self.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    public func addSlide(firstImage : UIImage, secondImage : UIImage, title : String, subtitle : String){
        NeonSlideItem.arrSlides.append(NeonSlideItem(firstImage: firstImage, secondImage: secondImage, title: title, subtitle: subtitle))
        slideCollectionView.objects = NeonSlideItem.arrSlides
        pageControl.numberOfPages = NeonSlideItem.arrSlides.count
    }
    
    public func addSlide(firstImageURL : String, secondImageURL : String, title : String, subtitle : String){
        NeonSlideItem.arrSlides.append(NeonSlideItem(firstImageURL: firstImageURL, secondImageURL: secondImageURL, title: title, subtitle: subtitle))
        slideCollectionView.objects = NeonSlideItem.arrSlides
        pageControl.numberOfPages = NeonSlideItem.arrSlides.count
    }
    
    func slideCollectionView(_ collectionView: NeonSlideCollectionView, destinationPage pageIndex: Int) {
        pageControl.set(progress: pageIndex, animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
