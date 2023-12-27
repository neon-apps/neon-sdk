//
//  NeonTestimonialView.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//

#if !os(xrOS)
import Foundation
import UIKit

@available(iOS 13.0, *)
public class NeonTestimonialView: UIView, NeonTestimonialCollectionViewDelegate {
    
    let testimonialCollectionView = NeonTestimonialCollectionView()
    var pageControl = NeonBasePageControl()

    public var intervalBetweenTestimonials = 5.0{
        didSet{
            testimonialCollectionView.intervalBetweenTestimonials = intervalBetweenTestimonials
        }
    }
    
    public var testimonialTextColor = UIColor.black{
        didSet{
            testimonialCollectionView.testimonialTextColor = testimonialTextColor
        }
    }
    public var testimonialbackgroundColor = UIColor.white{
        didSet{
            testimonialCollectionView.testimonialbackgroundColor = testimonialbackgroundColor
        }
    }
    public var testimonialbackgroundCornerRadious = 12{
        didSet{
            testimonialCollectionView.testimonialbackgroundCornerRadious = testimonialbackgroundCornerRadious
        }
    }
    
    public var currentTestimonialPageTintColor = UIColor.black{
        didSet{
            pageControl.currentPageTintColor = currentTestimonialPageTintColor
        }
    }
    
    public var testimonialPageTintColor = UIColor.black{
        didSet{
            pageControl.tintColor = testimonialPageTintColor
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

        
      
        addSubview(testimonialCollectionView)
        testimonialCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
        testimonialCollectionView.testimonialCollectionViewDelegate = self
     
   
    }
    
    func configurePageControl(){
        pageControl.removeFromSuperview()
        addSubview(pageControl)
        pageControl.radius = 3
        pageControl.currentPageTintColor = currentTestimonialPageTintColor
        pageControl.tintColor = testimonialPageTintColor
        pageControl.padding = 6
        pageControl.numberOfPages = testimonialCollectionView.arrTestimonials.count
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(testimonialCollectionView.snp.bottom).offset(10)
            make.bottom.equalTo(self.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    public func addTestimonial(title : String, testimonial : String, author : String){
        testimonialCollectionView.arrTestimonials.append(NeonTestimonial(title: title, testimonial: testimonial,author: author))
        testimonialCollectionView.objects = testimonialCollectionView.arrTestimonials
        pageControl.numberOfPages = testimonialCollectionView.arrTestimonials.count
    }
    func testimonialCollectionView(_ collectionView: NeonTestimonialCollectionView, destinationPage pageIndex: Int) {
        pageControl.set(progress: pageIndex, animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

#endif
