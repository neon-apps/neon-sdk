//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 22.10.2023.
//

import Foundation
import UIKit

public extension UIDevice {
    
    static let currentDeviceModel: DeviceModel = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> DeviceModel { // Updated function signature
                  switch identifier {
                  case "iPod5,1": return .iPodTouch5
                  case "iPod7,1": return .iPodTouch6
                  case "iPod9,1": return .iPodTouch7
                  case "iPhone3,1", "iPhone3,2", "iPhone3,3": return .iPhone4
                  case "iPhone4,1": return .iPhone4s
                  case "iPhone5,1", "iPhone5,2": return .iPhone5
                  case "iPhone5,3", "iPhone5,4": return .iPhone5c
                  case "iPhone6,1", "iPhone6,2": return .iPhone5s
                  case "iPhone7,2": return .iPhone6
                  case "iPhone7,1": return .iPhone6Plus
                  case "iPhone8,1": return .iPhone6s
                  case "iPhone8,2": return .iPhone6sPlus
                  case "iPhone9,1", "iPhone9,3": return .iPhone7
                  case "iPhone9,2", "iPhone9,4": return .iPhone7Plus
                  case "iPhone10,1", "iPhone10,4": return .iPhone8
                  case "iPhone10,2", "iPhone10,5": return .iPhone8Plus
                  case "iPhone10,3", "iPhone10,6": return .iPhoneX
                  case "iPhone11,2": return .iPhoneXS
                  case "iPhone11,4", "iPhone11,6": return .iPhoneXSMax
                  case "iPhone11,8": return .iPhoneXR
                  case "iPhone12,1": return .iPhone11
                  case "iPhone12,3": return .iPhone11Pro
                  case "iPhone12,5": return .iPhone11ProMax
                  case "iPhone13,1": return .iPhone12Mini
                  case "iPhone13,2": return .iPhone12
                  case "iPhone13,3": return .iPhone12Pro
                  case "iPhone13,4": return .iPhone12ProMax
                  case "iPhone14,4": return .iPhone13Mini
                  case "iPhone14,5": return .iPhone13
                  case "iPhone14,2": return .iPhone13Pro
                  case "iPhone14,3": return .iPhone13ProMax
                  case "iPhone14,7": return .iPhone14
                  case "iPhone14,8": return .iPhone14Plus
                  case "iPhone15,2": return .iPhone14Pro
                  case "iPhone15,3": return .iPhone14ProMax
                  case "iPhone15,4": return .iPhone15
                  case "iPhone15,5": return .iPhone15Plus
                  case "iPhone16,1": return .iPhone15Pro
                  case "iPhone16,2": return .iPhone15ProMax
                  case "iPhone8,4": return .iPhoneSE
                  case "iPhone12,8": return .iPhoneSE2
                  case "iPhone14,6": return .iPhoneSE3
                  case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return .iPad2
                  case "iPad3,1", "iPad3,2", "iPad3,3": return .iPad3
                  case "iPad3,4", "iPad3,5", "iPad3,6": return .iPad4
                  case "iPad6,11", "iPad6,12": return .iPad5
                  case "iPad7,5", "iPad7,6": return .iPad6
                  case "iPad7,11", "iPad7,12": return .iPad7
                  case "iPad11,6", "iPad11,7": return .iPad8
                  case "iPad12,1", "iPad12,2": return .iPad9
                  case "iPad13,18", "iPad13,19": return .iPad10
                  case "iPad4,1", "iPad4,2", "iPad4,3": return .iPadAir
                  case "iPad5,3", "iPad5,4": return .iPadAir2
                  case "iPad11,3", "iPad11,4": return .iPadAir3
                  case "iPad13,1", "iPad13,2": return .iPadAir4
                  case "iPad13,16", "iPad13,17": return .iPadAir5
                  case "iPad2,5", "iPad2,6", "iPad2,7": return .iPadMini
                  case "iPad4,4", "iPad4,5", "iPad4,6": return .iPadMini2
                  case "iPad4,7", "iPad4,8", "iPad4,9": return .iPadMini3
                  case "iPad5,1", "iPad5,2": return .iPadMini4
                  case "iPad11,1", "iPad11,2": return .iPadMini5
                  case "iPad14,1", "iPad14,2": return .iPadMini6
                  case "iPad6,3", "iPad6,4": return .iPadPro9_7
                  case "iPad7,3", "iPad7,4": return .iPadPro10_5
                  case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return .iPadPro11_1stGen
                  case "iPad8,9", "iPad8,10": return .iPadPro11_2ndGen
                  case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7": return .iPadPro11_3rdGen
                  case "iPad14,3", "iPad14,4": return .iPadPro11_4thGen
                  case "iPad6,7", "iPad6,8": return .iPadPro12_9_1stGen
                  case "iPad7,1", "iPad7,2": return .iPadPro12_9_2ndGen
                  case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return .iPadPro12_9_3rdGen
                  case "iPad8,11", "iPad8,12": return .iPadPro12_9_4thGen
                  case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11": return .iPadPro12_9_5thGen
                  case "iPad14,5", "iPad14,6": return .iPadPro12_9_6thGen
                  case "AppleTV5,3": return .appleTV
                  case "AppleTV6,2": return .appleTV4K
                  case "AudioAccessory1,1": return .homePod
                  case "AudioAccessory5,1": return .homePodMini
                  case "i386", "x86_64", "arm64": return .simulator
                  default: return .unknown // Return unknown for unrecognized models
                  }
              }
              
              return mapToDevice(identifier: identifier)
          }()
          
    
}

 
public enum DeviceModel: String {
    // iPhone
    case iPhone4 = "iPhone 4"
        case iPhone4s = "iPhone 4s"
        case iPhone5 = "iPhone 5"
        case iPhone5c = "iPhone 5c"
        case iPhone5s = "iPhone 5s"
        case iPhone6 = "iPhone 6"
        case iPhone6Plus = "iPhone 6 Plus"
        case iPhone6s = "iPhone 6s"
        case iPhone6sPlus = "iPhone 6s Plus"
        case iPhoneSE = "iPhone SE"
        case iPhoneSE2 = "iPhone SE (2nd gen)"
        case iPhoneSE3 = "iPhone SE (3rd gen)"
        case iPhone7 = "iPhone 7"
        case iPhone7Plus = "iPhone 7 Plus"
        case iPhone8 = "iPhone 8"
        case iPhone8Plus = "iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case iPhoneXS = "iPhone XS"
        case iPhoneXSMax = "iPhone XS Max"
        case iPhoneXR = "iPhone XR"
        case iPhone11 = "iPhone 11"
        case iPhone11Pro = "iPhone 11 Pro"
        case iPhone11ProMax = "iPhone 11 Pro Max"
        case iPhone12Mini = "iPhone 12 Mini"
        case iPhone12 = "iPhone 12"
        case iPhone12Pro = "iPhone 12 Pro"
        case iPhone12ProMax = "iPhone 12 Pro Max"
        case iPhone13Mini = "iPhone 13 Mini"
        case iPhone13 = "iPhone 13"
        case iPhone13Pro = "iPhone 13 Pro"
        case iPhone13ProMax = "iPhone 13 Pro Max"
        case iPhone14 = "iPhone 14"
        case iPhone14Plus = "iPhone 14 Plus"
        case iPhone14Pro = "iPhone 14 Pro"
        case iPhone14ProMax = "iPhone 14 Pro Max"
        case iPhone15 = "iPhone 15"
        case iPhone15Plus = "iPhone 15 Plus"
        case iPhone15Pro = "iPhone 15 Pro"
        case iPhone15ProMax = "iPhone 15 Pro Max"
        
        // iPod Touch
        case iPodTouch5 = "iPod Touch 5"
        case iPodTouch6 = "iPod Touch 6"
        case iPodTouch7 = "iPod Touch 7"
        
        // iPad
        case iPad2 = "iPad 2"
        case iPad3 = "iPad 3"
        case iPad4 = "iPad 4"
        case iPad5 = "iPad 5"
        case iPad6 = "iPad 6"
        case iPad7 = "iPad 7"
        case iPad8 = "iPad 8"
        case iPad9 = "iPad 9"
        case iPad10 = "iPad 10"
        case iPadAir = "iPad Air"
        case iPadAir2 = "iPad Air 2"
        case iPadAir3 = "iPad Air 3"
        case iPadAir4 = "iPad Air 4"
        case iPadAir5 = "iPad Air 5"
        case iPadMini = "iPad Mini"
        case iPadMini2 = "iPad Mini 2"
        case iPadMini3 = "iPad Mini 3"
        case iPadMini4 = "iPad Mini 4"
        case iPadMini5 = "iPad Mini 5"
        case iPadMini6 = "iPad Mini 6"
        case iPadPro9_7 = "iPad Pro 9.7-inch"
        case iPadPro10_5 = "iPad Pro 10.5-inch"
        case iPadPro11_1stGen = "iPad Pro 11-inch (1st gen)"
        case iPadPro11_2ndGen = "iPad Pro 11-inch (2nd gen)"
        case iPadPro11_3rdGen = "iPad Pro 11-inch (3rd gen)"
        case iPadPro11_4thGen = "iPad Pro 11-inch (4th gen)"
        case iPadPro11_5thGen = "iPad Pro 11-inch (5th gen)"
        case iPadPro12_9_1stGen = "iPad Pro 12.9-inch (1st gen)"
        case iPadPro12_9_2ndGen = "iPad Pro 12.9-inch (2nd gen)"
        case iPadPro12_9_3rdGen = "iPad Pro 12.9-inch (3rd gen)"
        case iPadPro12_9_4thGen = "iPad Pro 12.9-inch (4th gen)"
        case iPadPro12_9_5thGen = "iPad Pro 12.9-inch (5th gen)"
        case iPadPro12_9_6thGen = "iPad Pro 12.9-inch (6th gen)"
        
        // Apple TV
        case appleTV = "Apple TV"
        case appleTV4K = "Apple TV 4K"
        
        // HomePod
        case homePod = "HomePod"
        case homePodMini = "HomePod Mini"
        
        // Simulator
        case simulator = "Simulator"
        
        // Unknown
        case unknown = "Unknown" // Default case
    
    var screenHeight: CGFloat {
         switch self {
         case .iPhone4, .iPhone4s:
             return 480.0
         case .iPhone5, .iPhone5c, .iPhone5s:
             return 568.0
         case .iPhone6, .iPhone6s, .iPhone7, .iPhone8:
             return 667.0
         case .iPhone6Plus, .iPhone6sPlus, .iPhone7Plus, .iPhone8Plus:
             return 736.0
         case .iPhoneSE, .iPhoneSE2, .iPhoneSE3:
             return 667.0
         case .iPhoneX, .iPhoneXS, .iPhone11Pro:
             return 812.0
         case .iPhoneXSMax, .iPhone11ProMax:
             return 896.0
         case .iPhoneXR, .iPhone11:
             return 896.0
         case .iPhone12Mini:
             return 812.0
         case .iPhone12, .iPhone12Pro:
             return 844.0
         case .iPhone12ProMax:
             return 926.0
         case .iPhone13Mini:
             return 812.0
         case .iPhone13, .iPhone13Pro:
             return 844.0
         case .iPhone13ProMax:
             return 926.0
         case .iPhone14, .iPhone14Plus:
             return 926.0
         case .iPhone14Pro, .iPhone14ProMax:
             return 926.0
         case .iPhone15, .iPhone15Plus:
             return 926.0
         case .iPhone15Pro, .iPhone15ProMax:
             return 926.0
         case .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadMini5, .iPadMini6:
             return 1024.0
         case .iPad2, .iPad3, .iPad4:
             return 1024.0
         case .iPad5, .iPad6, .iPad7, .iPad8, .iPad9, .iPad10:
             return 1080.0
         case .iPadAir, .iPadAir2, .iPadAir3, .iPadAir4, .iPadAir5:
             return 1080.0
         case .iPadPro9_7, .iPadPro10_5:
             return 1024.0
         case .iPadPro11_1stGen, .iPadPro11_2ndGen, .iPadPro11_3rdGen, .iPadPro11_4thGen, .iPadPro11_5thGen:
             return 834.0
         case .iPadPro12_9_1stGen, .iPadPro12_9_2ndGen, .iPadPro12_9_3rdGen, .iPadPro12_9_4thGen, .iPadPro12_9_5thGen, .iPadPro12_9_6thGen:
             return 1024.0
         case .simulator:
             return 926
         default:
             return 0.0
         }
     }
    
    public func isLargerThan(_ otherDevice: DeviceModel) -> Bool {
           return self.screenHeight > otherDevice.screenHeight
       }
       
    public func isSmallerThan(_ otherDevice: DeviceModel) -> Bool {
           return self.screenHeight < otherDevice.screenHeight
    }
    
    public func isEqualOrLargerThan(_ otherDevice: DeviceModel) -> Bool {
           return self.screenHeight >= otherDevice.screenHeight
       }
       
    public func isEqualOrSmallerThan(_ otherDevice: DeviceModel) -> Bool {
           return self.screenHeight <= otherDevice.screenHeight
    }
    
    
    public var stringValue : String{
        return self.rawValue
    }
     
}
