//
//  ShimmeringViewProtocol.swift
//  UIView-Shimmer
//
//  Created by Ömer Faruk Öztürk on 15.01.2021.
//

import UIKit

public protocol ShimmeringViewProtocol where Self: UIView {
    var shimmerItems: [UIView] { get }
    var excludedItems: Set<UIView> { get }
}

extension ShimmeringViewProtocol {
    public var shimmerItems: [UIView] { [self] }
    public var excludedItems: Set<UIView> { [] }
}
