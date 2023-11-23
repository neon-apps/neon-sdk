//
//  NeonLongOnboardingPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
public class NeonLongOnboardingPage{
    
    
   
    var id = UUID().uuidString
    var type : NeonLongOnboardingPageType
    var isQuestion = Bool()
    var sectionIndex : Int {
        get{
            for (sectionIndex, section) in NeonLongOnboardingConstants.sections.enumerated(){
                for (_, page) in section.pages.enumerated(){
                    if self.id == page.id{
                        return sectionIndex
                    }
                }
            }
            fatalError("This page not exist in any sections.")
        }
       
    }
    var indexInSection : Int{
        get{
            for (_, section) in NeonLongOnboardingConstants.sections.enumerated(){
                for (pageIndex, page) in section.pages.enumerated(){
                    if self.id == page.id{
                        return pageIndex
                    }
                }
            }
            fatalError("This page not exist in any sections.")
        }
    }
    
    var indexInSectionQuestions : Int{
        get{
            for (_, section) in NeonLongOnboardingConstants.sections.enumerated(){
                for (pageIndex, page) in section.questionPages.enumerated(){
                    if self.id == page.id{
                        return pageIndex
                    }
                }
            }
            return -1
        }
    }
    
    var controller : UIViewController{
        switch self.type {
        case .singleSelection(_,_,_,_):
            return NeonLongOnboardingSingleSelectionPage()
        case .multipleSelection(_,_,_,_):
            return NeonLongOnboardingMultipleSelectionPage()
        case .information(_,_,_):
            return NeonLongOnboardingInformationPage()
        case .beforeAfter(_,_,_,_):
            return NeonLongOnboardingBeforeAfterPage()
        case .name(_,_,_):
            return NeonLongOnboardingNamePage()
        case .number(_,_,_):
            return NeonLongOnboardingNumberPage()
        case .greatFit(_,_,_,_):
            return NeonLongOnboardingGreatFitPage()
        case .customPlan(_,_,_,_,_,_,_):
            return NeonLongOnboardingCustomPlanPage()
        case .contract(_,_,_):
            return NeonLongOnboardingContractPage()
        case .letsGo(_,_,_):
            return NeonLongOnboardingLetsGoPage()
        case .statement(_,_,_):
            return NeonLongOnboardingStatementPage()
        case .slider(_,_,_,_,_,_,_):
            return NeonLongOnboardingSliderPage()
        case .text(_,_,_):
            return NeonLongOnboardingTextPage()
        case .sayGoodbye(_,_):
            return NeonLongOnboardingSayGoodbyePage()
        case .custom(let controller, let isQuesiton):
            self.isQuestion = isQuesiton
            return controller
        case .analyzing(_,_,_,_,_):
            return NeonLongOnboardingAnalyzingPage()
        case .testimonial(_,_,_,_,_):
            return NeonLongOnboardingTestimonialPage()
        }
        
    }
    
    
    internal init(type: NeonLongOnboardingPageType) {
        self.type = type
        
        switch type {
        case .singleSelection(_,_,_,_):
            isQuestion = true
        case .multipleSelection(_,_,_,_):
            isQuestion = true
        case .information(_,_,_):
            isQuestion = false
        case .beforeAfter(_,_,_,_):
            isQuestion = false
        case .name(_,_,_):
            isQuestion = true
        case .number(_,_,_):
            isQuestion = true
        case .greatFit(_,_,_,_):
            isQuestion = false
        case .customPlan(_,_,_,_,_,_,_):
            isQuestion = false
        case .contract(_,_,_):
            isQuestion = false
        case .letsGo(_,_,_):
            isQuestion = false
        case .statement(_,_,_):
            isQuestion = false
        case .slider(_,_,_,_,_,_,_):
            isQuestion = true
        case .text(_,_,_):
            isQuestion = true
        case .sayGoodbye(_,_):
            isQuestion = false
        case .custom(let controller, let isQuesiton):
            self.isQuestion = isQuesiton
        case .analyzing(_,_,_,_,_):
            isQuestion = false
        case .testimonial(_,_,_,_,_):
            isQuestion = false
        }
    }
}


