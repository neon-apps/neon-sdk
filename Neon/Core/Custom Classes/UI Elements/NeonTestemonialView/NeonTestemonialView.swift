//
//  NeonTestemonialView.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public class NeonTestemonialView: UIView, NeonTestemonialCollectionViewDelegate {
    
    let testemonialCollectionView = NeonTestemonialCollectionView()
    var pageControl = NeonBasePageControl()

    public var intervalBetweenTestemonials = 5.0{
        didSet{
            testemonialCollectionView.intervalBetweenTestemonials = intervalBetweenTestemonials
        }
    }
    
    public var testemonialTextColor = UIColor.black{
        didSet{
            testemonialCollectionView.testemonialTextColor = testemonialTextColor
        }
    }
    public var testemonialbackgroundColor = UIColor.white{
        didSet{
            testemonialCollectionView.testemonialbackgroundColor = testemonialbackgroundColor
        }
    }
    public var testemonialbackgroundCornerRadious = 12{
        didSet{
            testemonialCollectionView.testemonialbackgroundCornerRadious = testemonialbackgroundCornerRadious
        }
    }
    
    public var currentTestemonialPageTintColor = UIColor.black{
        didSet{
            pageControl.currentPageTintColor = currentTestemonialPageTintColor
        }
    }
    
    public var testemonialPageTintColor = UIColor.black{
        didSet{
            pageControl.tintColor = testemonialPageTintColor
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

        
      
        addSubview(testemonialCollectionView)
        testemonialCollectionView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
        testemonialCollectionView.testemonialCollectionViewDelegate = self
     
   
    }
    
    func configurePageControl(){
        pageControl.removeFromSuperview()
        addSubview(pageControl)
        pageControl.radius = 3
        pageControl.currentPageTintColor = currentTestemonialPageTintColor
        pageControl.tintColor = testemonialPageTintColor
        pageControl.padding = 6
        pageControl.numberOfPages = NeonTestemonial.arrTestemonials.count
        pageControl.snp.makeConstraints { make in
            make.top.equalTo(testemonialCollectionView.snp.bottom).offset(10)
            make.bottom.equalTo(self.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
    public func addTestemonial(title : String, testemonial : String, author : String){
        NeonTestemonial.arrTestemonials.append(NeonTestemonial(title: title, testemonial: testemonial,author: author))
        testemonialCollectionView.objects = NeonTestemonial.arrTestemonials
        pageControl.numberOfPages = NeonTestemonial.arrTestemonials.count
    }
    func testemonialCollectionView(_ collectionView: NeonTestemonialCollectionView, destinationPage pageIndex: Int) {
        pageControl.set(progress: pageIndex, animated: true)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

