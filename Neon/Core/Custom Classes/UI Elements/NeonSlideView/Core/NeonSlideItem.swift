//
//  NeonSlideItem.swift
//  Cleaner
//
//  Created by Tuna Öztürk on 7.06.2023.
//
#if !os(xrOS)
import Foundation
import NeonSDK
import UIKit

public class NeonSlideItem{
    
    public init(firstImage: UIImage, secondImage: UIImage, title: String, subtitle: String) {
        self.firstImage = firstImage
        self.secondImage = secondImage
        self.title = title
        self.subtitle = subtitle
    }

    public var firstImage : UIImage
    public var secondImage : UIImage
    public var title = String()
    public var subtitle = String()
  
    
    static var arrSlides = [NeonSlideItem]()
}
#endif
