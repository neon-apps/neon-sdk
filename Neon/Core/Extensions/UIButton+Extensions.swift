//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 11.03.2023.
//

import Foundation
import UIKit

extension UIButton {
    public func addUnderline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.underlineColor,
                                      value: self.titleColor(for: .normal)!,
                                      range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor,
                                      value: self.titleColor(for: .normal)!,
                                      range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
