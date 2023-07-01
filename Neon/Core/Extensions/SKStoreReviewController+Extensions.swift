//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 11.03.2023.
//
#if !os(xrOS)
import Foundation
import StoreKit

extension SKStoreReviewController {
    public class func requestReviewInCurrentScene() {
        if #available(iOS 13.0, *) {
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                if #available(iOS 14.0, *) {
                    requestReview(in: scene)
                } else {
                    // Fallback on earlier versions
                    requestReview()
                }
            }
        } else {
            // Fallback on earlier versions
            requestReview()
        }
    }
}
#endif
