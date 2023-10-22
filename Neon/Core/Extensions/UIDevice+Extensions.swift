//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 22.10.2023.
//

import Foundation
import UIKit

public extension UIDevice {
    
    public static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
#if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPhone14,7":                                    return "iPhone 14"
            case "iPhone14,8":                                    return "iPhone 14 Plus"
            case "iPhone15,2":                                    return "iPhone 14 Pro"
            case "iPhone15,3":                                    return "iPhone 14 Pro Max"
            case "iPhone15,4":                                    return "iPhone 15"
            case "iPhone15,5":                                    return "iPhone 15 Plus"
            case "iPhone16,1":                                    return "iPhone 15 Pro"
            case "iPhone16,2":                                    return "iPhone 15 Pro Max"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad13,18", "iPad13,19":                        return "iPad (10th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad14,3", "iPad14,4":                          return "iPad Pro (11-inch) (4th generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "iPad14,5", "iPad14,6":                          return "iPad Pro (12.9-inch) (6th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
#elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
#endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}

 
public enum DeviceModel: String {
    // iPhone
    case iPhone4
    case iPhone4s
    case iPhone5
    case iPhone5c
    case iPhone5s
    case iPhone6
    case iPhone6Plus
    case iPhone6s
    case iPhone6sPlus
    case iPhoneSE
    case iPhoneSE2
    case iPhoneSE3
    case iPhone7
    case iPhone7Plus
    case iPhone8
    case iPhone8Plus
    case iPhoneX
    case iPhoneXS
    case iPhoneXSMax
    case iPhoneXR
    case iPhone11
    case iPhone11Pro
    case iPhone11ProMax
    case iPhone12Mini
    case iPhone12
    case iPhone12Pro
    case iPhone12ProMax
    case iPhone13Mini
    case iPhone13
    case iPhone13Pro
    case iPhone13ProMax
    case iPhone14
    case iPhone14Plus
    case iPhone14Pro
    case iPhone14ProMax
    case iPhone15
    case iPhone15Plus
    case iPhone15Pro
    case iPhone15ProMax
    
    // iPod Touch
    case iPodTouch5
    case iPodTouch6
    case iPodTouch7
    
    // iPad
    case iPad2
    case iPad3
    case iPad4
    case iPad5
    case iPad6
    case iPad7
    case iPad8
    case iPad9
    case iPad10
    case iPadAir
    case iPadAir2
    case iPadAir3
    case iPadAir4
    case iPadAir5
    case iPadMini
    case iPadMini2
    case iPadMini3
    case iPadMini4
    case iPadMini5
    case iPadMini6
    case iPadPro9_7
    case iPadPro10_5
    case iPadPro11_1stGen
    case iPadPro11_2ndGen
    case iPadPro11_3rdGen
    case iPadPro11_4thGen
    case iPadPro11_5thGen
    case iPadPro12_9_1stGen
    case iPadPro12_9_2ndGen
    case iPadPro12_9_3rdGen
    case iPadPro12_9_4thGen
    case iPadPro12_9_5thGen
    case iPadPro12_9_6thGen
    
    // Apple TV
    case appleTV
    case appleTV4K
    
    // HomePod
    case homePod
    case homePodMini
    
    // Simulator
    case simulator
    
    // Unknown
    case unknown // Default case
    
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
         default:
             return 0.0
         }
     }
    
    func isLargerThan(_ otherDevice: DeviceModel) -> Bool {
           return self.screenHeight > otherDevice.screenHeight
       }
       
       func isSmallerThan(_ otherDevice: DeviceModel) -> Bool {
           return self.screenHeight < otherDevice.screenHeight
       }
     
}

public extension UIDevice {
    
    // Get the model name of the current device
    static var currentDeviceModel: DeviceModel {
        let modelName = UIDevice.modelName
        
        switch modelName {
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
    
    
}
