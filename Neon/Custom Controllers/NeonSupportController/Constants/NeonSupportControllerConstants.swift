//
//  NeonSupportControllerConstants.swift
//  WatermarkRemover
//
//  Created by Tuna Öztürk on 21.10.2023.
//

import Foundation
import UIKit

public class NeonSupportControllerConstants{
    
    static var arrSupportTypes: [NeonSupportType] = [
        NeonSupportType(
            title: "Contact Us",
            icon: UIImage(named: "icon_contact", in: Bundle.module, compatibleWith: nil)!,
            placeholder: "Got questions? We've got answers! Reach out anytime.",
            ctaButtonTitle: "Give a High-Five",
            controllerType: .contactUs,
            successMessageTitle: "Thank You!",
            successMessage: "Your message has been sent successfully! Our friendly support team will get back to you as soon as they catch a falling star."
        ),
        NeonSupportType(
            title: "Report a Bug",
            icon: UIImage(named: "icon_bug", in: Bundle.module, compatibleWith: nil)!,
            placeholder: "Uh-oh, a bug? Let us know, and we'll squish it!",
            ctaButtonTitle: "Spot the Buggy",
            controllerType: .bugReport,
            successMessageTitle: "Bug Reported!",
            successMessage: "Your bug report has been received! Our bug-catching experts are on the case, ready to send that bug packing to Buglandia!"
        ),
        NeonSupportType(
            title: "Give Feedback",
            icon: UIImage(named: "icon_feedback", in: Bundle.module, compatibleWith: nil)!,
            placeholder: "Share your thoughts! We're all ears.",
            ctaButtonTitle: "Brighten Our Day",
            controllerType: .feedback,
            successMessageTitle: "Feedback Received!",
            successMessage: "Thanks for sharing your wonderful feedback with us! Your thoughts light up our day like a thousand fireflies."
        ),
        NeonSupportType(
            title: "Request a Feature",
            icon: UIImage(named: "icon_feature", in: Bundle.module, compatibleWith: nil)!,
            placeholder: "Wish for a feature? We'll make it happen!",
            ctaButtonTitle: "Make a Wish!",
            controllerType: .featureRequest,
            successMessageTitle: "Feature Requested!",
            successMessage: "Your feature request has been noted! Our feature-making fairies will work their magic to grant your wishes in future updates."
        )
    ]

    static var choosenSupportType = arrSupportTypes.first!
    
    public enum ControllerType : String{
        case standard = "Help & Support"
        case contactUs = "Contact Us"
        case bugReport = "Report a Bug"
        case feedback = "Give Feedback"
        case featureRequest = "Request a Feature"
    }
    
    static var choosenControllerType = ControllerType.standard
    
    
    static var backgroundColor = UIColor()
    static var mainColor = UIColor()
    static var buttonTextColor = UIColor ()
    static var textButtonColor = UIColor()
    static var containerColor = UIColor()
    static var textColor = UIColor()
    static var placeholderColor = UIColor()
    
}

