//
//  Testemonial.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//

import Foundation


class NeonTestemonial{
    
    internal init(title: String = String(), testemonial: String = String(), author: String = String()) {
        self.title = title
        self.testemonial = testemonial
        self.author = author
    }

    var title = String()
    var testemonial = String()
    var author = String()
    
    static var arrTestemonials = [NeonTestemonial]()
}
