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

public enum AttributeType {
    case color(UIColor)
    case underline
    case font(UIFont)
    case backgroundColor(UIColor)
    case strikethrough
    case kerning(CGFloat)
    case lineSpacing(CGFloat)
    case shadow(NSShadow)
    case action(() -> Void)
}

extension UILabel {
    
    public func applyAttribute(substring: String, type: AttributeType) {
        guard let attributedText = self.attributedText else {
            return
        }
        
        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
        let range = (attributedText.string as NSString).range(of: substring)
        
        if range.location != NSNotFound {
            switch type {
            case .color(let color):
                mutableAttributedText.addAttribute(.foregroundColor, value: color, range: range)
            case .underline:
                mutableAttributedText.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            case .font(let font):
                mutableAttributedText.addAttribute(.font, value: font, range: range)
            case .backgroundColor(let backgroundColor):
                mutableAttributedText.addAttribute(.backgroundColor, value: backgroundColor, range: range)
            case .strikethrough:
                mutableAttributedText.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            case .kerning(let kerning):
                mutableAttributedText.addAttribute(.kern, value: kerning, range: range)
            case .lineSpacing(let lineSpacing):
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = lineSpacing
                mutableAttributedText.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
            case .shadow(let shadow):
                mutableAttributedText.addAttribute(.shadow, value: shadow, range: range)
            case .action(let action):
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                self.isUserInteractionEnabled = true
                self.addGestureRecognizer(tapGestureRecognizer)
                self.actionForRange[range] = action
            }
            
            self.attributedText = mutableAttributedText
        }
    }
    
    private var actionForRange: [NSRange: () -> Void] {
        get {
            if let dictionary = objc_getAssociatedObject(self, &AssociatedKeys.actionForRange) as? [NSRange: () -> Void] {
                return dictionary
            }
            return [:]
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.actionForRange, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let tapLocation = gestureRecognizer.location(in: self)
        if let (word, range) = wordAtLocation(tapLocation) {
            if let action = actionForRange[range] {
                action()
            }
        }
    }
    
    private func wordAtLocation(_ location: CGPoint) -> (String, NSRange)? {
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: self.attributedText ?? NSAttributedString())
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.size = self.bounds.size
        
        let characterIndex = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        for (range, _) in actionForRange {
            if NSLocationInRange(characterIndex, range) {
                let word = (self.text as NSString?)?.substring(with: range)
                return (word ?? "", range)
            }
        }
        
        return nil
    }
    
    private struct AssociatedKeys {
        static var actionForRange = "actionForRange"
    }
}

