//
//  Testimonial.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//
#if !os(xrOS)
import Foundation


public class NeonTestimonial{
    
    public init(title: String = String(), testimonial: String = String(), author: String = String()) {
        self.title = title
        self.testimonial = testimonial
        self.author = author
    }

    public var title = String()
    public var testimonial = String()
    public var author = String()
    
}
#endif
