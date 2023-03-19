//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit

class FontManager{
    
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

