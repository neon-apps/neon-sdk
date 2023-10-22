//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 22.10.2023.
//

import Foundation

@available(iOS 13.0, *)
public class NeonAlertManager {
    // Static property to access DefaultAlertManager
    public static let `default` = DefaultAlertManager.self

    // Static property to access CustomAlertManager
    public static let custom = CustomAlertManager.self

    // Private initializer to prevent external instantiation
    private init() { }
}
