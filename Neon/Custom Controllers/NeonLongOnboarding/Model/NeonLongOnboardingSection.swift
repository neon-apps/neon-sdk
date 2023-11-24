//
//  NeonLongOnboardingSection.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation

@available(iOS 13.0, *)
public class NeonLongOnboardingSection{
    
    private static var lastSectionIndex = -1
    
    var title : String
    var pages = [NeonLongOnboardingPage]()
    var questionPages : [NeonLongOnboardingPage]{
        get{
            return pages.filter({$0.isQuestion})
        }
    }
    var index = Int()
    
    internal init(title: String) {
        self.title = title
        self.index = NeonLongOnboardingSection.lastSectionIndex + 1
        NeonLongOnboardingSection.lastSectionIndex = self.index
    }
    
    public func addPage(type : NeonLongOnboardingPageType){
        let newPage = NeonLongOnboardingPage(type: type)
        self.pages.append(newPage)
        checkPageCount()
    }
    func checkPageCount(){
        if self.questionPages.count > 5{
            fatalError("You can't add more than 5 question page to single section.")
        }
    }
}
