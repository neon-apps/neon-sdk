//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 22.10.2023.
//

import Foundation
import UIKit

public class NeonDeviceManager {
    
    public static var currentDeviceModel: DeviceModel {
        return UIDevice.currentDeviceModel
    }
    
    public static func isCurrentDeviceLargerThan(_ otherDevice: DeviceModel) -> Bool {
        return currentDeviceModel.isLargerThan(otherDevice)
    }
    
    public static func isCurrentDeviceSmallerThan(_ otherDevice: DeviceModel) -> Bool {
        return currentDeviceModel.isSmallerThan(otherDevice)
    }

}

