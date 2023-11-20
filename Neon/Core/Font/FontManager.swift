//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit

public class FontManager{
    
    static let shared = FontManager()
    
    public enum FontWeight {
        case Light
        case Regular
        case Medium
        case SemiBold
        case Bold
        case Black
    }

    public enum FontType {
        case Poppins
        case SFProDisplay
        case SFProText
        case Inter
        case Montserrat
        case None
    }
     var choosenFontType = FontType.None
    
    public func registerFonts() {
        for font in arrFonts{
            registerFont(bundle: .module, fontName: font.fileName, fontExtension: font.fileExtension)
        }
    }

   fileprivate func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {

       guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension),
             let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
             let font = CGFont(fontDataProvider) else {
                 fatalError("Couldn't create font from data")
       }

       var error: Unmanaged<CFError>?

       CTFontManagerRegisterGraphicsFont(font, &error)
   }
    
}

