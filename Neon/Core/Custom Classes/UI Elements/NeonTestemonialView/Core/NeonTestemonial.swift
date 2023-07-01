//
//  Testemonial.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//
#if !os(xrOS)
import Foundation


public class NeonTestemonial{
    
    public init(title: String = String(), testemonial: String = String(), author: String = String()) {
        self.title = title
        self.testemonial = testemonial
        self.author = author
    }

    public var title = String()
    public var testemonial = String()
    public var author = String()
    
    static var arrTestemonials = [NeonTestemonial]()
}
#endif
