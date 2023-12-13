//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit


public class Font {
  
    
    public static var adjustSizeWithScreen : Bool = false
    
    public static func configureFonts(font : FontManager.FontType){
        FontManager.shared.registerFonts()
        FontManager.shared.choosenFontType = font
    }
    
    public static func custom(size: CGFloat, fontWeight: FontManager.FontWeight) -> UIFont {
   
         var fontWeightStr = "\(fontWeight)"
         
        if FontManager.shared.choosenFontType == .SFProDisplay ||  FontManager.shared.choosenFontType == .SFProText{
             fontWeightStr = fontWeightStr.lowercased()
             fontWeightStr = fontWeightStr.capitalized
         }


        if adjustSizeWithScreen{
            return UIFont(name: "\(FontManager.shared.choosenFontType)-\(fontWeightStr)", size: size * UIScreen.main.bounds.height * 0.00115)!
        }else{
            return UIFont(name: "\(FontManager.shared.choosenFontType)-\(fontWeightStr)", size: size)!
        }
      


    }
    
}


