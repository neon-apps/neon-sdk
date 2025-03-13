//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import UIKit
import Foundation
import AppTrackingTransparency
import AdSupport

public class Neon{
    public static var isUserPremium = false
    public static var isPremiumTestActive = false
    static var homeVC = UIViewController()
    static var onboardingVC = UIViewController()
    static var paywallVC = UIViewController()
    
    public static func setWindow( window : inout UIWindow?, destinationVC: UIViewController, interfaceStyle: UIUserInterfaceStyle = .light) {
#if !os(xrOS)
        window = UIWindow(frame: UIScreen.main.bounds)
#else
        window = UIWindow()
#endif
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = interfaceStyle
        }
        window?.makeKeyAndVisible()
        window?.rootViewController = destinationVC
    }
    
    public static func configure(window : inout UIWindow?, onboardingVC : UIViewController, paywallVC : UIViewController, homeVC : UIViewController, splashVC : UIViewController? = nil, enableKeyboardManager : Bool = true, interfaceStyle: UIUserInterfaceStyle = .light){
#if !os(xrOS)
        if enableKeyboardManager{
            configureIQKeyboard()
        }
#endif
        SettingsManager.fetchAppID { appID in
            NeonAppTracking.createDevice(appID : appID, completion: {
                NeonAppTracking.trackSession()
            })
        }
        
        
        self.homeVC = homeVC
        self.paywallVC = paywallVC
        self.onboardingVC = onboardingVC
        
        if let splashVC{
            Neon.setWindow(window: &window, destinationVC: splashVC, interfaceStyle: interfaceStyle)
        }else{
            
        if !UserDefaults.standard.bool(forKey: "Neon-isOnboardingCompleted"){
            Neon.setWindow(window: &window, destinationVC: onboardingVC, interfaceStyle: interfaceStyle)
            return
        }
        
        if Neon.isUserPremium || UserDefaults.standard.bool(forKey: "Neon-IsUserPremium"){
            Neon.setWindow(window: &window, destinationVC: homeVC, interfaceStyle: interfaceStyle)
        }else{
            Neon.setWindow(window: &window, destinationVC: paywallVC, interfaceStyle: interfaceStyle)
        }
            
        }
        
    }
#if !os(xrOS)
    fileprivate static func configureIQKeyboard(){
        IQKeyboardManager.shared.enable = true
    }
#endif
    public static func onboardingCompleted(){
        NeonAppTracking.trackOnboardingCompletion()
        UserDefaults.standard.setValue(true, forKey: "Neon-isOnboardingCompleted")
    }
    public static var isOnboardingCompleted : Bool{
        return UserDefaults.standard.bool(forKey: "Neon-isOnboardingCompleted")
    }

    public static func requestIDFA(completion: ((_ authorized: Bool) -> Void)? = nil) {
        ATTrackingManager.requestTrackingAuthorization { status in
            switch status {
            case .authorized:
                let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                NeonAppTracking.updateIdfa(idfa: idfa)
                completion?(true)
            case .denied, .restricted, .notDetermined:
                completion?(false)
            @unknown default:
                completion?(false)
            }
        }
    }


    public static func paywallPresented(){
        NeonAppTracking.trackPaywallView()
    }
    
    public static func activatePremiumTest(){
        #if DEBUG
        isPremiumTestActive = true
        Neon.isUserPremium = true
        #endif
    }
}
