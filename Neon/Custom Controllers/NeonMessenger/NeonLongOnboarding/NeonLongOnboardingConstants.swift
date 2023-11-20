//
//  NeonLongOnboardingConstants.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public class NeonLongOnboardingConstants{
    
    static var currentPage : NeonLongOnboardingPage?
    static var currentSection : NeonLongOnboardingSection?
    static var responses = [NeonLongOnboardingResponse]()
    static var sections = [NeonLongOnboardingSection]()
    
    static var buttonColor = UIColor()
    static var buttonTextColor = UIColor()
    static var disabledButtonColor = UIColor()
    static var disabledButtonTextColor = UIColor()
    static var pageBackgroundColor = UIColor()
    static var optionBackgroundColor = UIColor()
    static var optionBorderColor = UIColor()
    static var selectedOptionBackgroundColor = UIColor()
    static var selectedOptionBorderColor = UIColor()
    static var textColor = UIColor()
    
    static var upcomingProgressBackgroundColor = UIColor()
    static var upcomingProgressTextColor = UIColor()
    static var completedProgressBackgroundColor = UIColor()
    static var completedProgressTextColor = UIColor()
    
    static var selectedOptionImage = UIImage()
    
    static var ctaButtonTitle = String()
    
    // UserInfo
    
    static var firstName : String?
}
