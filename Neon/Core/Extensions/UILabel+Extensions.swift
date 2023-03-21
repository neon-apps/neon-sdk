//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 11.03.2023.
//

import Foundation
import UIKit

extension UILabel {
    public func setTextWithLineSpace(text: String, spacing: CGFloat = 6) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        self.attributedText = attributedString
    }

    public func setTextWithLeftImage(image: UIImage, text: String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)
        let string = NSMutableAttributedString(string: text, attributes: [:])
        mutableAttributedString.append(string)
        self.attributedText = mutableAttributedString
    }
}
