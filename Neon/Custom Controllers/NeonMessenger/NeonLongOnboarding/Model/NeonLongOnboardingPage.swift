//
//  NeonLongOnboardingPage.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit

public class NeonLongOnboardingPage{
    
    
    var controller = UIViewController()
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
    
    internal init(type: NeonLongOnboardingPageType) {
        self.type = type
        switch type {
        case .singleSelection(_,_,_,_):
            isQuestion = true
            controller = NeonLongOnboardingSingleSelectionPage()
        case .multipleSelection(_,_,_,_):
            isQuestion = true
            controller = NeonLongOnboardingMultipleSelectionPage()
        case .information(_,_,_):
            isQuestion = false
            controller = NeonLongOnboardingInformationPage()
        case .beforeAfter(_,_,_,_):
            isQuestion = false
            controller = NeonLongOnboardingBeforeAfterPage()
        case .name(_,_,_):
            isQuestion = true
            controller = NeonLongOnboardingNamePage()
        case .number(_,_,_):
            isQuestion = true
            controller = NeonLongOnboardingNumberPage()
        case .greatFit(_,_,_,_):
            isQuestion = false
            controller = NeonLongOnboardingGreatFitPage()
        case .customPlan(_,_,_,_,_,_,_):
            isQuestion = false
            controller = NeonLongOnboardingCustomPlanPage()
        case .contract(_,_,_):
            isQuestion = false
            controller = NeonLongOnboardingContractPage()
        case .letsGo(_,_):
            isQuestion = false
            controller = NeonLongOnboardingLetsGoPage()
        case .statement(_,_,_):
            isQuestion = false
            controller = NeonLongOnboardingStatementPage()
        case .slider(_,_,_,_,_,_,_):
            isQuestion = true
            controller = NeonLongOnboardingSliderPage()
        case .text(_,_,_):
            isQuestion = true
            controller = NeonLongOnboardingTextPage()
        case .sayGoodbye(_,_):
            isQuestion = false
            controller = NeonLongOnboardingSayGoodbyePage()
        case .custom(let controller, let isQuesiton):
            self.isQuestion = isQuesiton
            self.controller = controller
        case .analyzing(_,_,_,_,_):
            isQuestion = false
            controller = NeonLongOnboardingAnalyzingPage()
        case .testimonial(_,_,_,_,_):
            isQuestion = false
            controller = NeonLongOnboardingTestimonialPage()
        }
        
    }
}


