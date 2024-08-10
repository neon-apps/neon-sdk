//
//  PaddedLabel.swift
//  PromotionCode
//
//  Created by cihangirincaz on 1.08.2024.
//

import UIKit

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets.zero

    override func drawText(in rect: CGRect) {
        let insetsRect = rect.inset(by: textInsets)
        super.drawText(in: insetsRect)
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        let width = size.width + textInsets.left + textInsets.right
        let height = size.height + textInsets.top + textInsets.bottom
        return CGSize(width: width, height: height)
    }
}
