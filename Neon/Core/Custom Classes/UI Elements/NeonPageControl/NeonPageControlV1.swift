//
//  NeonPageControlV1.swift


import Foundation
import UIKit

open class NeonPageControlV1: NeonBasePageControl {

    @IBInspectable open var elementWidth: CGFloat = 20 {
        didSet {
            setNeedsLayout()
        }
    }

    @IBInspectable open var elementHeight: CGFloat = 6 {
        didSet {
            setNeedsLayout()
        }
    }

    fileprivate var inactive = [NeonLayer]()
    fileprivate var active = NeonLayer()

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    override func updateNumberOfPages(_ count: Int) {
        inactive.forEach { $0.removeFromSuperlayer() }
        inactive = [NeonLayer]()
        inactive = (0..<count).map {_ in
            let layer = NeonLayer()
            self.layer.addSublayer(layer)
            return layer
        }

        self.layer.addSublayer(active)

        setNeedsLayout()
        self.invalidateIntrinsicContentSize()
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        
        let floatCount = CGFloat(inactive.count)
        let x = (self.bounds.size.width - self.elementWidth*floatCount - self.padding*(floatCount-1))*0.5
        let y = (self.bounds.size.height - self.elementHeight)*0.5
        var frame = CGRect(x: x, y: y, width: self.elementWidth, height: self.elementHeight)

        active.cornerRadius = self.radius
        active.backgroundColor = (self.currentPageTintColor ?? self.tintColor)?.cgColor
        active.frame = frame

        inactive.enumerated().forEach() { index, layer in
            layer.backgroundColor = self.tintColor(position: index).withAlphaComponent(self.inactiveTransparency).cgColor
            if self.borderWidth > 0 {
                layer.borderWidth = self.borderWidth
                layer.borderColor = self.tintColor(position: index).cgColor
            }
            layer.cornerRadius = self.radius
            layer.frame = frame
            frame.origin.x += self.elementWidth + self.padding
        }
        update(for: progress)
    }

    override func update(for progress: Double) {
        guard let min = inactive.first?.frame,
              let max = inactive.last?.frame,
              progress >= 0 && progress <= Double(numberOfPages - 1),
              numberOfPages > 1 else {
                return
        }

        let total = Double(numberOfPages - 1)
        let dist = max.origin.x - min.origin.x
        let percent = CGFloat(progress / total)

        let offset = dist * percent
        active.frame.origin.x = min.origin.x + offset

    }

    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(inactive.count) * self.elementWidth + CGFloat(inactive.count - 1) * self.padding,
                      height: self.elementHeight)
    }

    override open func didTouch(gesture: UITapGestureRecognizer) {
        let point = gesture.location(ofTouch: 0, in: self)
        if let touchIndex = inactive.enumerated().first(where: { $0.element.hitTest(point) != nil })?.offset {
            delegate?.didTouch(pager: self, index: touchIndex)
        }
    }
}
