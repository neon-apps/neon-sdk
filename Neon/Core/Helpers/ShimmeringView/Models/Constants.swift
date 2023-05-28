//
//  Constants.swift
//  UIView-Shimmer
//
//  Created by Ömer Faruk Öztürk on 8.01.2021.
//

import UIKit

struct Key {
    static let shimmer = "Key.ShimmerLayer"
    static let template = "Key.TemplateLayer"
    static let teijinKey = "Z6LDUFCJXTHUKXKHCWJ72RJVPHWZZVHB"
}

public class ShimmerManager{
    
    public static func configure(shimmerColor : UIColor, shimmerBackgroundColor : UIColor ){
        self.shimmerColor = shimmerColor
        self.shimmerBackgroundColor = shimmerBackgroundColor
    }
    public static var shimmerColor = UIColor()
    public static var shimmerBackgroundColor = UIColor()
}
