//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import UIKit
import Foundation

public class Neon{
    public static var isUserPremium = false
    static var isPremiumTestActive = false
    
    public static func setWindow( window : inout UIWindow?, destinationVC: UIViewController) {
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        window?.makeKeyAndVisible()
        window?.rootViewController = destinationVC
    }
    
    public static func configure(window : inout UIWindow?, onboardingVC : UIViewController, paywallVC : UIViewController, homeVC : UIViewController){
        
        configureIQKeyboard()
        
        if !UserDefaults.standard.bool(forKey: "Neon-isOnboardingCompleted"){
            Neon.setWindow(window: &window, destinationVC: onboardingVC)
            return
        }
        
        if Neon.isUserPremium || UserDefaults.standard.bool(forKey: "Neon-IsUserPremium"){
            Neon.setWindow(window: &window, destinationVC: homeVC)
        }else{
            Neon.setWindow(window: &window, destinationVC: paywallVC)
        }
        
    }
    
    fileprivate static func configureIQKeyboard(){
        IQKeyboardManager.shared.enable = true
    }
    
    public static func onboardingCompleted(){
        UserDefaults.standard.setValue(true, forKey: "Neon-isOnboardingCompleted")
    }
    public static var isOnboardingCompleted : Bool{
        return UserDefaults.standard.bool(forKey: "Neon-isOnboardingCompleted")
    }
    
    public static func activatePremiumTest(){
        #if DEBUG
        isPremiumTestActive = true
        Neon.isUserPremium = true
        #endif
    }
}
