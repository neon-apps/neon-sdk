//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 11.03.2023.
//
#if !os(xrOS)
import Foundation
import UIKit
import SDWebImage


extension UIImageView{
   
    public func setImage(urlString : String){
    self.sd_imageTransition = .fade
    self.sd_setImage(with: URL(string: urlString), completed: { [] (image, error, cacheType, url) in })
  
  }
}
#endif
