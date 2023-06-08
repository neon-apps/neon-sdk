//
//  NeonPageControllable.swift
//  NeonPageControl  

import Foundation
import CoreGraphics
import UIKit

protocol NeonPageControllable: AnyObject {
    var numberOfPages: Int { get set }
    var currentPage: Int { get }
    var progress: Double { get set }
    var hidesForSinglePage: Bool { get set }
    var borderWidth: CGFloat { get set }

    func set(progress: Int, animated: Bool)
}
