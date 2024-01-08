//
//  WhatYouWillGetItem.swift
//  NeonLongOnboardingPlayground
//
//  Created by Tuna Öztürk on 2.12.2023.
//

import Foundation

public class NeonLongPaywallWhatYouWillGetItem{
    public var emoji = String()
    public var title = String()
    public var subtitle = String()
    
    public init(emoji: String, title: String, subtitle: String) {
        self.emoji = emoji
        self.title = title
        self.subtitle = subtitle
    }
}
