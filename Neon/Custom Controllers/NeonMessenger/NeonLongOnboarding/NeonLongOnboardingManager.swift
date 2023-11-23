//
//  NeonLongOnboardingManager.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit
import NeonSDK

protocol NeonLongOnboardingManagerProtocol {
    func responseReceived(question : String, response : [Any], responseType : NeonLongOnboardingResponseType)
    func onboardingCompleted(controller : UIViewController)
    func pagePresented(page : UIViewController)
}
@available(iOS 13.0, *)
public class NeonLongOnboardingManager{
    
    static var delegate : NeonLongOnboardingManagerProtocol?
    
    public static func configureColors(buttonColor: UIColor,
                                buttonTextColor: UIColor,
                                disabledButtonColor: UIColor,
                                disabledButtonTextColor: UIColor,
                                pageBackgroundColor: UIColor,
                                optionBackgroundColor: UIColor,
                                optionBorderColor: UIColor,
                                selectedOptionBackgroundColor: UIColor,
                                selectedOptionBorderColor: UIColor,
                                textColor: UIColor,
                                upcomingProgressBackgroundColor: UIColor,
                                upcomingProgressTextColor: UIColor,
                                completedProgressBackgroundColor: UIColor,
                                completedProgressTextColor: UIColor) {

        NeonLongOnboardingConstants.buttonColor = buttonColor
        NeonLongOnboardingConstants.buttonTextColor = buttonTextColor
        NeonLongOnboardingConstants.disabledButtonColor = disabledButtonColor
        NeonLongOnboardingConstants.disabledButtonTextColor = disabledButtonTextColor
        NeonLongOnboardingConstants.pageBackgroundColor = pageBackgroundColor
        NeonLongOnboardingConstants.optionBackgroundColor = optionBackgroundColor
        NeonLongOnboardingConstants.optionBorderColor = optionBorderColor
        NeonLongOnboardingConstants.selectedOptionBackgroundColor = selectedOptionBackgroundColor
        NeonLongOnboardingConstants.selectedOptionBorderColor = selectedOptionBorderColor
        NeonLongOnboardingConstants.textColor = textColor

  
        NeonLongOnboardingConstants.upcomingProgressBackgroundColor = upcomingProgressBackgroundColor
        NeonLongOnboardingConstants.upcomingProgressTextColor = upcomingProgressTextColor
        NeonLongOnboardingConstants.completedProgressBackgroundColor = completedProgressBackgroundColor
        NeonLongOnboardingConstants.completedProgressTextColor = completedProgressTextColor
    }
    
    public static func configureImages(selectedOptionImage : UIImage = NeonSymbols.checkmark_seal_fill){
        NeonLongOnboardingConstants.selectedOptionImage = selectedOptionImage
    }
    
    public static func configureCopy(ctaButtonTitle : String = "Next"){
        NeonLongOnboardingConstants.ctaButtonTitle = ctaButtonTitle
    }
    public static func moveToNextPage(controller : UIViewController){
        
        if let currentPage = NeonLongOnboardingConstants.currentPage, let currentSection = NeonLongOnboardingConstants.currentSection{
            if currentSection.pages.count > currentPage.indexInSection + 1{
                // There or more pages in current section
                NeonLongOnboardingConstants.currentPage = currentSection.pages[currentPage.indexInSection + 1]
                
                controller.present(destinationVC: NeonLongOnboardingConstants.currentPage!.controller, slideDirection: .right)
                delegate?.pagePresented(page: NeonLongOnboardingConstants.currentPage!.controller)
            }else{
                // Move to new section if there is one
                
                if NeonLongOnboardingConstants.sections.count > currentSection.index + 1{
                    // There are more sections
                    NeonLongOnboardingConstants.currentSection = NeonLongOnboardingConstants.sections[currentSection.index + 1]
                    NeonLongOnboardingConstants.currentPage = NeonLongOnboardingConstants.currentSection!.pages.first
                    
                    controller.present(destinationVC: NeonLongOnboardingConstants.currentPage!.controller, slideDirection: .right)
                    delegate?.pagePresented(page: NeonLongOnboardingConstants.currentPage!.controller)
                }else{
                    // Onboarding completed
                    delegate?.onboardingCompleted(controller: controller)
                }
            }
        }
    
        
        
      
    }
    
    public static func moveToPreviousPage(controller : UIViewController) {
        if let currentPage = NeonLongOnboardingConstants.currentPage, let currentSection = NeonLongOnboardingConstants.currentSection {
            if currentPage.indexInSection > 0 {
                // There are previous pages in the current section
                NeonLongOnboardingConstants.currentPage = currentSection.pages[currentPage.indexInSection - 1]
                
                controller.dismiss(animated: true)
            } else {
                // Move to the previous section if there is one
                if currentSection.index > 0 {
                    // There are previous sections
                    NeonLongOnboardingConstants.currentSection = NeonLongOnboardingConstants.sections[currentSection.index - 1]
                    if let lastPage = NeonLongOnboardingConstants.currentSection?.pages.last {
                        NeonLongOnboardingConstants.currentPage = lastPage
                        controller.dismiss(animated: true)
                    }
                } else {
                    // This is the first page of the first section
                    print("Already at the beginning of Onboarding")
                }
            }
        }
    }

    public static func saveResponse(question : String, responses : [Any]){
        
        let newResponse = NeonLongOnboardingResponse(question: question, responses: responses)
        if let index = NeonLongOnboardingConstants.responses.firstIndex(where: {$0.question == newResponse.question}){
            // This question already saved, change response
            NeonLongOnboardingConstants.responses[index] = newResponse
            delegate?.responseReceived(question: question, response: responses, responseType: .responseUpdated)
            
        }else{
            // This question not saved yet
            NeonLongOnboardingConstants.responses.append(newResponse)
            delegate?.responseReceived(question: question, response: responses, responseType: .newResponse)
        }
    }
    
    
 
}
