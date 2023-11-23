//
//  NeonLongOnboardingPageType.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 14.11.2023.
//

import Foundation
import UIKit


public enum NeonLongOnboardingPageType{
    case singleSelection(question : String, subtitle: String?, options : [NeonLongOnboardingOption], whyDoWeAsk : String? = nil)
    case multipleSelection(question : String, subtitle: String?, options : [NeonLongOnboardingOption], whyDoWeAsk : String? = nil)
    case information(title : String, subtitle: String, description : String)
    case name(title : String, subtitle: String, description : String)
    case number(question : String, subtitle: String, digitCount : Int)
    case beforeAfter(title : String, subtitle: String?, beforeItems : [String], afterItems : [String])
    case greatFit(title : String, subtitle: String, benefits : [NeonLongOnboardingGreatFitBenefit], description : String)
    case customPlan(mainTitle: String, planTitle: String,planSubtitle: String, planItems : [String], secondTitle : String, descriptionTitle : String, description : String)
    case contract(emoji : String, title : String, items : [String])
    case letsGo(question : String, image : UIImage, hideNoButton : Bool = false)
    case statement(title : String, statement : String, image : UIImage)
    case slider(question : String, item: String, descripiton: String, symbol: String, min : Float, max : Float, isSymbolBeforeValue : Bool = true)
    case text(question : String, subtitle: String?, placeholder: String)
    case sayGoodbye(title : String, items : [String])
    case custom(controller : UIViewController, isQuestion : Bool)
    case analyzing(title : String, subtitle : String, processedTitle : String, animation : NeonAnimationView, sectionProcessingDuration : Double)
    case testimonial(firstTitle : String, firstSubtitle : String, processingDuration : Double, processingTitle : String, testimonials : [NeonTestimonial])
    
}



