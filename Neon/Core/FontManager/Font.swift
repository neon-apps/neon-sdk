//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit


public class Font {

    public static let shared = Font()
    
    var choosenFontType = FontType.None
    
    public enum FontWeight {
        case Regular
        case Medium
        case SemiBold
        case Bold
    }
    
    public enum FontType {
        case Poppins
        case SFProDisplay
        case SFProText
        case Inter
        case None
    }
    
    public func configureFont(font : FontType){
        FontManager().registerFonts()
        self.choosenFontType = font
    }
    
    public func custom(size: CGFloat = 14, fontWeight: FontWeight = .Medium) -> UIFont {
   
         var fontWeightStr = "\(fontWeight)"
         
         if self.choosenFontType == .SFProDisplay ||  self.choosenFontType == .SFProText{
             fontWeightStr = fontWeightStr.lowercased()
             fontWeightStr = fontWeightStr.capitalized
         }
         
        return UIFont(name: "\(self.choosenFontType)-\(fontWeightStr)", size: size * UIScreen.main.bounds.height * 0.00115)!
    }
    
 
    

   
    
    
}
