//
//  NeonLongPaywallFAQItem.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 2.12.2023.
//

import Foundation

public class NeonLongPaywallFAQItem: Equatable{
    public var question = String()
    public var answerTitle = String()
    public var answerSubtitle = String()
    
    public init(question: String, answerTitle: String, answerSubtitle: String) {
        self.question = question
        self.answerTitle = answerTitle
        self.answerSubtitle = answerSubtitle
    }
    
    public static func == (lhs: NeonLongPaywallFAQItem, rhs: NeonLongPaywallFAQItem) -> Bool {
        return lhs.question == rhs.question &&
        lhs.answerTitle == rhs.answerTitle &&
        lhs.answerSubtitle == rhs.answerSubtitle
    }
}
