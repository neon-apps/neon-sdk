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

    /// Color for unselected (inactive) indicators. If nil, falls back to `tintColor` / `tintColors` with `inactiveTransparency`.
    @IBInspectable open var inactiveTintColor: UIColor? = nil {
        didSet { setNeedsLayout() }
    }

    /// Width for unselected indicators (dots). Defaults to a small circle look.
    @IBInspectable open var inactiveElementWidth: CGFloat = 6 {
        didSet { setNeedsLayout() }
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
        let activeW = self.elementWidth
        let inactiveW = activeW / 2
        let totalWidth = inactiveW * floatCount + self.padding * (floatCount - 1)
        let x = (self.bounds.size.width - totalWidth) * 0.5
        let y = (self.bounds.size.height - self.elementHeight) * 0.5
        var frame = CGRect(x: x, y: y, width: inactiveW, height: self.elementHeight)

        // Active (selected) pill – wider than inactive dots
        active.cornerRadius = self.elementHeight / 2
        active.backgroundColor = (self.currentPageTintColor ?? self.tintColor)?.cgColor
        active.frame = CGRect(x: frame.origin.x - (activeW - inactiveW)/2,
                              y: frame.origin.y,
                              width: activeW,
                              height: self.elementHeight)

        inactive.enumerated().forEach { index, layer in
            let base = (self.inactiveTintColor ?? self.tintColor(position: index))
            layer.backgroundColor = base.withAlphaComponent(self.inactiveTransparency).cgColor
            if self.borderWidth > 0 {
                layer.borderWidth = self.borderWidth
                layer.borderColor = base.cgColor
            }
            layer.cornerRadius = self.elementHeight / 2
            layer.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: inactiveW, height: self.elementHeight)
            frame.origin.x += inactiveW + self.padding
        }
        update(for: progress)
    }

    override func update(for progress: Double) {
        guard let first = inactive.first?.frame,
              let last = inactive.last?.frame,
              progress >= 0 && progress <= Double(numberOfPages - 1),
              numberOfPages > 1 else { return }

        let inactiveW = self.inactiveElementWidth
        let activeW = self.elementWidth
        let offsetAdjust = (activeW - inactiveW) / 2

        let total = Double(numberOfPages - 1)
        let minX = first.origin.x - offsetAdjust
        let maxX = last.origin.x - offsetAdjust
        let dist = maxX - minX
        let percent = CGFloat(progress / total)

        active.frame.origin.x = minX + dist * percent
    }

    override open var intrinsicContentSize: CGSize {
        return sizeThatFits(CGSize.zero)
    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: CGFloat(inactive.count) * self.inactiveElementWidth + CGFloat(inactive.count - 1) * self.padding,
                      height: self.elementHeight)
    }

    override open func didTouch(gesture: UITapGestureRecognizer) {
        let point = gesture.location(ofTouch: 0, in: self)
        if let touchIndex = inactive.enumerated().first(where: { $0.element.hitTest(point) != nil })?.offset {
            delegate?.didTouch(pager: self, index: touchIndex)
        }
    }
}
