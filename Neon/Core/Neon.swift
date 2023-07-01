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
#if !os(xrOS)
        window = UIWindow(frame: UIScreen.main.bounds)
#else
        window = UIWindow()
#endif
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        window?.makeKeyAndVisible()
        window?.rootViewController = destinationVC
    }
    
    public static func configure(window : inout UIWindow?, onboardingVC : UIViewController, paywallVC : UIViewController, homeVC : UIViewController){
#if !os(xrOS)
        configureIQKeyboard()
#endif
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
#if !os(xrOS)
    fileprivate static func configureIQKeyboard(){
        IQKeyboardManager.shared.enable = true
    }
#endif
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
