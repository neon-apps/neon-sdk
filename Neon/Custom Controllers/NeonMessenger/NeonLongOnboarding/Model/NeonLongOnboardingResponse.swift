//
//  NeonLongOnboardingResponse.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 11.11.2023.
//

import Foundation


public enum NeonLongOnboardingResponseType{
    case newResponse
    case responseUpdated
}

class NeonLongOnboardingResponse{
    
    internal init(question: String, responses: [Any]) {
        self.question = question
        self.responses = responses
    }
    
    var question : String
    var responses : [Any]
}


extension [NeonLongOnboardingResponse]{
    func mapAsString() -> String{
        var responseString = String()
        
        for page in self{
            responseString += "Question :"
            responseString += "\(page.question)\n"
            responseString += "Responses\n"
            for response in page.responses{
                responseString += "\(response)\n"
            }
        }
        return responseString
    }
}
