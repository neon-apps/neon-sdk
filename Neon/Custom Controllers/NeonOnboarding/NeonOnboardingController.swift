//
//  NeonOnboarding.swift
//  Neon Educations
//
//  Created by Tuna Öztürk on 8.10.2023.
//

import UIKit

@available(iOS 13.0, *)
open class NeonOnboardingController: UIViewController {
    
    private let backgroundImageView = UIImageView()
    private let continueButton = UIButton()
    private var pageControl = NeonBasePageControl()
    private let fadeView = UIView()
    private let fadeLayer = CAGradientLayer()
    private var pages = [NeonOnboardingPage]()
    private var currentPage = NeonOnboardingPage()
    private var contentCollectionView = NeonCollectionView<NeonOnboardingPage, NeonOnboardingPageCell>()
    
    public enum BackgroundType{
        case fullBackgroundImage(layerColor : UIColor, layerOpacity : CGFloat)
        case halfBackgroundImage(backgroundColor : UIColor, offset : CGFloat, isFaded : Bool)
        case topVectorImage(backgroundColor : UIColor, offset : CGFloat, horizontalPadding : CGFloat)
    }
    
    open override func viewDidLayoutSubviews() {
        fadeLayer.frame = fadeView.bounds
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        createUI()
        
    }
    
    private func createUI(){
        
        backgroundImageView.layer.masksToBounds = true
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        
        view.addSubview(fadeView)
        fadeLayer.locations = [0, 1]
        fadeView.layer.insertSublayer(fadeLayer, at: 0)
        
        continueButton.layer.masksToBounds = true
        view.addSubview(continueButton)
        continueButton.addTarget(self, action: #selector(continueButtonClicked), for: .touchUpInside)
        
         contentCollectionView = NeonCollectionView<NeonOnboardingPage, NeonOnboardingPageCell>(
            objects: pages,
            leftPadding: 0,
            rightPadding: 0,
            horizontalItemSpacing: 0,
            widthForItem: UIScreen.main.bounds.width)
        contentCollectionView.backgroundColor = .clear
        contentCollectionView.isScrollEnabled = false
        view.addSubview(contentCollectionView)
        
     
    }
    
   
  
    
    @objc private func continueButtonClicked(){
        
      
        let nextIndex = currentPage.index + 1
        if pages.count > nextIndex{
            vibrate(style: .medium)
            currentPage = pages[nextIndex]
            setContent()
        }else{
            vibrate(style: .heavy)
            Neon.onboardingCompleted()
            onboardingCompleted()
        }
    }
    
 
    
    
}


@available(iOS 13.0, *)
extension NeonOnboardingController{
    
    public func configureBackground(type : BackgroundType){
        
        switch type {
        case .fullBackgroundImage(let layerColor, let layerOpacity):
            backgroundImageView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            contentCollectionView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(pageControl.snp.top).offset(-10)
                make.height.equalTo(200)
            }
            
            fadeLayer.colors = [layerColor.cgColor, layerColor.cgColor]
            fadeView.alpha = layerOpacity
            fadeView.snp.makeConstraints { make in
                make.edges.equalTo(backgroundImageView)
            }
            
            break
        case .halfBackgroundImage(let backgroundColor, let offset, let isFaded):
            
            view.backgroundColor = backgroundColor
            backgroundImageView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview()
                make.bottom.equalTo(view.snp.centerY).offset(offset)
            }
            
         
            if isFaded{
                fadeLayer.colors = [UIColor.clear.cgColor, backgroundColor.cgColor]
                fadeView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(backgroundImageView.snp.bottom)
                    make.height.equalTo(200)
                }
                
                contentCollectionView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(pageControl.snp.top).offset(-10)
                    make.top.equalTo(fadeView.snp.centerY)
                }
                
                
            }else{
                fadeLayer.colors = [backgroundColor.cgColor, backgroundColor.cgColor]
                fadeView.layer.cornerRadius = 30
                fadeView.layer.masksToBounds = true
                fadeView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.top.equalTo(backgroundImageView.snp.bottom).offset(-50)
                    make.bottom.equalToSuperview()
                }
                
                contentCollectionView.snp.makeConstraints { make in
                    make.left.right.equalToSuperview()
                    make.bottom.equalTo(pageControl.snp.top).offset(-10)
                    make.top.equalTo(fadeView.snp.top)
                }
                
            }
            
          
            
            break
        case .topVectorImage(let backgroundColor, let offset, let horizontalPadding):
            
            view.backgroundColor = backgroundColor
            backgroundImageView.contentMode = .scaleAspectFit
            backgroundImageView.snp.makeConstraints { make in
                make.left.right.top.equalToSuperview().inset(horizontalPadding)
                make.bottom.equalTo(view.snp.centerY).offset(offset)
            }
            
            contentCollectionView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalTo(pageControl.snp.top).offset(-10)
                make.top.equalTo(backgroundImageView.snp.bottom)
            }
            
            
            
            break
        }
    }
    
    
    public func configureButton(title : String,
                                titleColor : UIColor,
                                font : UIFont,
                                cornerRadious : CGFloat,
                                height : CGFloat,
                                horizontalPadding : CGFloat,
                                bottomPadding : CGFloat,
                                backgroundColor : UIColor?,
                                borderColor : UIColor?,
                                borderWidth : CGFloat?){
        
        if let backgroundColor{
            continueButton.backgroundColor = backgroundColor
        }
        
        if let borderColor, let borderWidth{
            continueButton.layer.borderColor = borderColor.cgColor
            continueButton.layer.borderWidth = borderWidth
        }
        
        continueButton.titleLabel?.font = font
        continueButton.setTitle(title, for: .normal)
        continueButton.setTitleColor(titleColor, for: .normal)
        continueButton.layer.cornerRadius = cornerRadious
        continueButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(horizontalPadding)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(bottomPadding)
            make.height.equalTo(height)
        }
        
        configurePageControl(type: .V1, currentPageTintColor: .white, tintColor: .lightGray)
        
        
    }
    
    public func configureText(titleColor : UIColor, titleFont : UIFont, subtitleColor : UIColor, subtitleFont : UIFont){
        NeonOnboardingPageCell.titleColor = titleColor
        NeonOnboardingPageCell.subtitleColor = subtitleColor
        NeonOnboardingPageCell.titleFont = titleFont
        NeonOnboardingPageCell.subtitleFont = subtitleFont
    }
    
 @objc open func onboardingCompleted(){
        
    }
    
    
    public func addPage(title: String, subtitle : String, image : UIImage ){
        let newPage = NeonOnboardingPage(title: title, subtitle: subtitle, image: image)
        newPage.index = pages.count
        pages.append(newPage)
        pageControl.numberOfPages = pages.count
        contentCollectionView.objects = pages
        if !pages.isEmpty{
            currentPage = pages.first!
            setContent()
        }
    }
    
    public func setContent(){
        contentCollectionView.scrollToItem(at: IndexPath(item: currentPage.index, section: 0), at: .centeredHorizontally, animated: true)
        pageControl.set(progress: currentPage.index, animated: true)
        UIView.transition(with: backgroundImageView,
                          duration: 0.75,
                          options: .transitionCrossDissolve,
                          animations: { self.backgroundImageView.image = self.currentPage.image },
                          completion: nil)
    }
    
    public func configurePageControl(type : PageControlType, currentPageTintColor : UIColor, tintColor : UIColor, radius : CGFloat = 3, padding : CGFloat = 6){
        
        switch type {
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
        
        pageControl.removeFromSuperview()
        view.addSubview(pageControl)
        pageControl.radius = radius
        pageControl.currentPageTintColor = currentPageTintColor
        pageControl.tintColor = tintColor
        pageControl.padding = padding
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(continueButton.snp.top).offset(-40)
            make.centerX.equalToSuperview()
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
}



