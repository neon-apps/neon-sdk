//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 9.07.2023.
//

import Foundation
import UIKit
@available(iOS 13.0, *)
public class NeonSplashVC: UIViewController {
    
    var timer: Timer?
    let progressView = NeonGradientProgressBar()

    var animationDuration : TimeInterval
    var appName : String
    var progressBarColors : [UIColor]
    var appIcon : UIImage
    public init(appIcon : UIImage, appName : String, progressBarColors : [UIColor], animationDuration : TimeInterval = 3){
        self.animationDuration = animationDuration
        self.progressBarColors = progressBarColors
        self.appName = appName
        self.appIcon = appIcon
        super.init(nibName: nil, bundle: nil)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        createUI()
        
    }
    
    
    public override func viewDidAppear(_ animated: Bool) {
     
        progressView.animationDuration = animationDuration
        self.progressView.setProgress(1, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration , execute: { [self] in
            adjustWindow()
        })
    }
    
    func createUI(){
        view.backgroundColor = .black
        
        let imgAppIcon = UIImageView()
        imgAppIcon.image = appIcon
        imgAppIcon.layer.masksToBounds = true
        imgAppIcon.layer.cornerRadius = 20
        imgAppIcon.contentMode = .scaleAspectFill
        view.addSubview(imgAppIcon)
        
        imgAppIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
        }
        
        let lblAppTitle = UILabel()
        lblAppTitle.text = appName
        lblAppTitle.font = Font.custom(size: 30, fontWeight: .SemiBold)
        lblAppTitle.textColor = .white
        lblAppTitle.textAlignment = .center
        lblAppTitle.sizeToFit()
        view.addSubview(lblAppTitle)
        
        lblAppTitle.snp.makeConstraints { make in
            make.top.equalTo(imgAppIcon.snp.bottom).offset(38)
            make.centerX.equalToSuperview()
            make.left.right.equalToSuperview().inset(30)
        }
        
        if progressBarColors.count == 1{
            progressBarColors.append(progressBarColors.first!)
        }
        progressView.progress = 0
        progressView.gradientColors = progressBarColors
        view.addSubview(progressView)
        progressView.layer.cornerRadius = 3
        progressView.layer.masksToBounds = true
        progressView.snp.makeConstraints { make in
            make.top.equalTo(lblAppTitle.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.equalTo(120)
            make.height.equalTo(6)
        }
       
        progressView.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    }
    @objc func adjustWindow() {
        if Neon.isOnboardingCompleted{
            if Neon.isUserPremium || UserDefaults.standard.bool(forKey: "Neon-IsUserPremium"){
                present(destinationVC: Neon.homeVC, slideDirection: .right)
            }else{
                present(destinationVC: Neon.paywallVC, slideDirection: .right)
            }
        }else{
            present(destinationVC: Neon.onboardingVC, slideDirection: .right)
            
        }
      
    }
}
