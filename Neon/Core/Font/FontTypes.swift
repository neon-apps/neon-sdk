//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 19.03.2023.
//

import Foundation


class NeonFont{
    
    internal init(fileName : String, fileExtension : String, postScriptName : String ) {
        self.fileName = fileName
        self.fileExtension = fileExtension
        self.postScriptName = postScriptName
    }
    
   
    var fileName = ""
    var postScriptName = ""
    var fileExtension = ""
}

let arrFonts = [
    NeonFont(fileName: "SF-Pro-Display-Regular", fileExtension: "otf", postScriptName: "SFProDisplay-Regular"),
    NeonFont(fileName: "SF-Pro-Display-Medium", fileExtension: "otf", postScriptName: "SFProDisplay-Medium"),
    NeonFont(fileName: "SF-Pro-Display-Semibold", fileExtension: "otf", postScriptName: "SFProDisplay-Semibold"),
    NeonFont(fileName: "SF-Pro-Display-Bold", fileExtension: "otf", postScriptName: "SFProDisplay-Bold"),
    NeonFont(fileName: "SF-Pro-Display-Light", fileExtension: "otf", postScriptName: "SFProDisplay-Light"),
    NeonFont(fileName: "SF-Pro-Display-Black", fileExtension: "otf", postScriptName: "SFProDisplay-Black"),
    
    NeonFont(fileName: "SF-Pro-Text-Regular", fileExtension: "otf", postScriptName: "SFProText-Regular"),
    NeonFont(fileName: "SF-Pro-Text-Medium", fileExtension: "otf", postScriptName: "SFProText-Medium"),
    NeonFont(fileName: "SF-Pro-Text-Semibold", fileExtension: "otf", postScriptName: "SFProText-Semibold"),
    NeonFont(fileName: "SF-Pro-Text-Bold", fileExtension: "otf", postScriptName: "SFProText-Bold"),
    NeonFont(fileName: "SF-Pro-Text-Light", fileExtension: "otf", postScriptName: "SFProText-Light"),
    NeonFont(fileName: "SF-Pro-Text-Black", fileExtension: "otf", postScriptName: "SFProText-Black"),
    
    NeonFont(fileName: "Inter-Regular", fileExtension: "ttf", postScriptName: "Inter-Regular"),
    NeonFont(fileName: "Inter-Medium", fileExtension: "ttf", postScriptName: "Inter-Medium"),
    NeonFont(fileName: "Inter-SemiBold", fileExtension: "ttf", postScriptName: "Inter-SemiBold"),
    NeonFont(fileName: "Inter-Bold", fileExtension: "ttf", postScriptName: "Inter-Bold"),
    NeonFont(fileName: "Inter-Light", fileExtension: "ttf", postScriptName: "Inter-Light"),
    NeonFont(fileName: "Inter-Black", fileExtension: "ttf", postScriptName: "Inter-Black"),
    
    NeonFont(fileName: "Poppins-Regular", fileExtension: "ttf", postScriptName: "Poppins-Regular"),
    NeonFont(fileName: "Poppins-Medium", fileExtension: "ttf", postScriptName: "Poppins-Medium"),
    NeonFont(fileName: "Poppins-SemiBold", fileExtension: "ttf", postScriptName: "Poppins-SemiBold"),
    NeonFont(fileName: "Poppins-Bold", fileExtension: "ttf", postScriptName: "Poppins-Bold"),
    NeonFont(fileName: "Poppins-Light", fileExtension: "ttf", postScriptName: "Poppins-Light"),
    NeonFont(fileName: "Poppins-Black", fileExtension: "ttf", postScriptName: "Poppins-Black"),
    
    NeonFont(fileName: "Montserrat-Regular", fileExtension: "ttf", postScriptName: "Montserrat-Regular"),
    NeonFont(fileName: "Montserrat-Medium", fileExtension: "ttf", postScriptName: "Montserrat-Medium"),
    NeonFont(fileName: "Montserrat-SemiBold", fileExtension: "ttf", postScriptName: "Montserrat-SemiBold"),
    NeonFont(fileName: "Montserrat-Bold", fileExtension: "ttf", postScriptName: "Montserrat-Bold"),
    NeonFont(fileName: "Montserrat-Light", fileExtension: "ttf", postScriptName: "Montserrat-Light"),
    NeonFont(fileName: "Montserrat-Black", fileExtension: "ttf", postScriptName: "Montserrat-Black"),
    
]
