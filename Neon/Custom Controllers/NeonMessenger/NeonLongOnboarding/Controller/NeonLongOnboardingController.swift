//
//  NeonLongOnboardingController.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
open class NeonLongOnboardingController: UIViewController, NeonLongOnboardingManagerProtocol {
  
   
    

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        NeonLongOnboardingManager.delegate = self

    }
    
    public func createSection(title : String) -> NeonLongOnboardingSection{
        let newSection = NeonLongOnboardingSection(title: title)
        return newSection
    }
    
    public func configureSections(sections : [NeonLongOnboardingSection]){
        NeonLongOnboardingConstants.sections = sections
    }
    
    public func startOnboarding(controller : UIViewController){
        guard let firstSection = NeonLongOnboardingConstants.sections.first, let firstPage = firstSection.pages.first else {
                fatalError("You should add at least one section and one page to use NeonLongOnboarding.")
        }

        NeonLongOnboardingConstants.currentPage = firstPage
        NeonLongOnboardingConstants.currentSection = firstSection
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
            controller.present(destinationVC: firstPage.controller, slideDirection: .right)
        })
    }
    
  
  
    open func responseReceived(question : String, response : [Any], responseType : NeonLongOnboardingResponseType){}
    
    open func pagePresented(page : UIViewController){}

    open func onboardingCompleted(controller : UIViewController) {
        
    }
    

}
