//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation
import UIKit

enum FontManagerError: Error {
    case failedToRegisterFont
}

public class FontManager{
    
    public static let shared = FontManager()
    
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

    public var choosenFontType = FontType.None

    public func registerFonts() throws {
        for font in arrFonts{
            try registerFont(bundle: .module, fontName: font.fileName, fontExtension: font.fileExtension)
        }
    }

   fileprivate func registerFont(bundle: Bundle, fontName: String, fontExtension: String) throws{
       guard let asset = NSDataAsset(name: "Fonts/\(fontName)", bundle: bundle),
             let provider = CGDataProvider(data: asset.data as NSData),
             let font = CGFont(provider),
             CTFontManagerRegisterGraphicsFont(font, nil) else {
           print("Mert1: ", FontManagerError.failedToRegisterFont)
           throw FontManagerError.failedToRegisterFont
          }
   }
    
}

