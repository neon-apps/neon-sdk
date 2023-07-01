//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 7.05.2023.
//
#if !os(xrOS)
import Foundation
import Localize_Swift

import UIKit

public enum NeonScrollDirection {
    case right
    case left
}

open class NeonScrollLabel: UIView {

    private static let kLabelCount: Int = 2
    private static let kDefaultFadeLength: CGFloat = 7.0
    private static let kDefaultLabelBufferSpace: CGFloat = 20  // Pixel buffer space between scrolling label
    private static let kDefaultPixelsPerSecond: Double = 14.0
    private static let kDefaultPauseTime: Double = 1.5

    public var scrollDirection = NeonScrollDirection.right {
        didSet {
            scrollLabelIfNeeded()
        }
    }

    // Pixels per second, defaults to 14
    public var scrollSpeed = NeonScrollLabel.kDefaultPixelsPerSecond {
        didSet {
            scrollLabelIfNeeded()
        }
    }

    // Defaults to 1.5
    public var pauseInterval = NeonScrollLabel.kDefaultPauseTime

    // Pixels, defaults to 20
    public var labelSpacing = NeonScrollLabel.kDefaultLabelBufferSpace

    public var animationOptions: UIView.AnimationOptions = UIView.AnimationOptions.curveLinear

    // Returns YES, if it is actively scrolling, NO if it has paused or if text is within bounds (disables scrolling).
    public var scrolling = false

    // Defaults to 7
    public var fadeLength = NeonScrollLabel.kDefaultFadeLength {
        didSet {
            if oldValue != fadeLength {
                refreshLabels()
                applyGradientMaskForFadeLength(fadeLengthIn: fadeLength, enableFade: false)
            }
        }
    }

    // UILabel properties
    public var text: String? {
        get {
            return mainLabel.text
        }
        set {
            setText(text: newValue, refresh: true)
        }
    }

    public func setText(text: String?, refresh: Bool) {
        // Ignore identical text changes
        if text == self.text {
            return
        }

        for l in labels {
            l.text = text?.localized()
        }

        if refresh {
            refreshLabels()
        }
    }

    public var attributedText: NSAttributedString? {
        get {
            return mainLabel.attributedText
        }
        set {
            setAttributedText(text: newValue, refresh: true)
        }
    }

    public func setAttributedText(text: NSAttributedString?, refresh: Bool) {
        if text == self.attributedText {
            return
        }
        for l in labels {
            l.attributedText = NSAttributedString(string: text?.string.localized() ?? "")
        }
        if refresh {
            refreshLabels()
        }
    }

    public var textColor: UIColor! {
        get {
            return self.mainLabel.textColor
        }
        set {
            for lab in labels {
                lab.textColor = newValue
            }
        }
    }

    public var font: UIFont! {
        get {
            return mainLabel.font
        }
        set {
            for lab in labels {
                lab.font = newValue
            }
            refreshLabels()
            invalidateIntrinsicContentSize()
        }
    }

    public var shadowColor: UIColor? {
        get {
            return self.mainLabel.shadowColor
        }
        set {
            for lab in labels {
                lab.shadowColor = newValue
            }
        }
    }

    public var shadowOffset: CGSize {
        get {
            return self.mainLabel.shadowOffset
        }
        set {
            for lab in labels {
                lab.shadowOffset = newValue
            }
        }
    }

    public override var intrinsicContentSize: CGSize {
        get {
            return CGSize(width: 0.0, height: self.mainLabel.intrinsicContentSize.height)
        }
    }

    // Only applies when not auto-scrolling
    public var textAlignment: NSTextAlignment = .left

    // Views
    private var labels: [UILabel] = {
        var ls: [UILabel] = [UILabel]()
        for index in 0 ..< NeonScrollLabel.kLabelCount {
            ls.append(UILabel())
        }
        return ls
    }()
    private var mainLabel: UILabel {
        return labels.first ?? UILabel()
    }

    lazy public private(set) var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: self.bounds)
        sv.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        sv.backgroundColor = UIColor.clear
        return sv
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        assert(NeonScrollLabel.kLabelCount > 0, "NeonScrollLabel.kLabelCount must be greater than zero!")

        addSubview(scrollView)

        // Create the labels
        for index in 0 ..< NeonScrollLabel.kLabelCount {
            labels[index].backgroundColor = UIColor.clear
            labels[index].autoresizingMask = autoresizingMask
            self.scrollView.addSubview(labels[index])
        }

        // Default values
        self.scrollDirection = NeonScrollDirection.left
        self.scrollSpeed = NeonScrollLabel.kDefaultPixelsPerSecond
        self.pauseInterval = NeonScrollLabel.kDefaultPauseTime
        self.labelSpacing = NeonScrollLabel.kDefaultLabelBufferSpace
        self.fadeLength = NeonScrollLabel.kDefaultFadeLength
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.isScrollEnabled = false
        self.isUserInteractionEnabled = false
        self.backgroundColor = UIColor.clear
        self.clipsToBounds = true

        // Active
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.observeApplicationNotifications()
        }
    }

    public override var frame: CGRect {
        get {
            return super.frame
        }
        set {
            super.frame = newValue
            didChangeFrame()
        }
    }

    public override var bounds: CGRect {
        get {
            return super.bounds
        }
        set {
            super.bounds = newValue
            didChangeFrame()
        }
    }

    private func didChangeFrame() {
        refreshLabels()
        applyGradientMaskForFadeLength(fadeLengthIn: self.fadeLength, enableFade: self.scrolling)
    }

    public func observeApplicationNotifications() {
        NotificationCenter.default.removeObserver(self)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NeonScrollLabel.scrollLabelIfNeeded),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(NeonScrollLabel.scrollLabelIfNeeded),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    @objc private func enableShadow() {
        scrolling = true
        self.applyGradientMaskForFadeLength(fadeLengthIn: self.fadeLength, enableFade: true)
    }

    @objc public func scrollLabelIfNeeded() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.text == nil || self.text?.isEmpty == true {
                return
            }
            self.scrollLabelIfNeededAction()
        }
    }

    func scrollLabelIfNeededAction() {
        let labelWidth = self.mainLabel.bounds.width
        if labelWidth <= self.bounds.width {
            return
        }

        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(NeonScrollLabel.scrollLabelIfNeeded), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(NeonScrollLabel.enableShadow), object: nil)

        self.scrollView.layer.removeAllAnimations()

        let doScrollLeft = self.scrollDirection == NeonScrollDirection.left
        self.scrollView.contentOffset = doScrollLeft ? .zero : CGPoint(x: labelWidth + self.labelSpacing, y: 0)

        self.perform(#selector(NeonScrollLabel.enableShadow), with: nil, afterDelay: self.pauseInterval)

        // Animate the scrolling
        let duration = Double(labelWidth) / self.scrollSpeed

        UIView.animate(
            withDuration: duration,
            delay: self.pauseInterval,
            options: [self.animationOptions, UIView.AnimationOptions.allowUserInteraction],
            animations: { [weak self] () -> Void in
                guard let self = self else { return }
                // Adjust offset
                let offsetTodo: CGPoint = CGPoint(x: labelWidth + self.labelSpacing, y: 0)
                self.scrollView.contentOffset = doScrollLeft ? offsetTodo : CGPoint.zero
        }) { [weak self] finished in
            guard let self = self else { return }
            self.scrolling = false

            // Remove the left shadow
            self.applyGradientMaskForFadeLength(fadeLengthIn: self.fadeLength, enableFade: false)

            // Setup pause delay/loop
            if finished {
                self.performSelector(inBackground: #selector(NeonScrollLabel.scrollLabelIfNeeded), with: nil)
            }
        }
    }

    @objc private func refreshLabels() {
        var offset = CGFloat(0)

        for lab in labels {
            lab.sizeToFit()

            var frame = lab.frame
            frame.origin = CGPoint(x: offset, y: 0)
            frame.size.height = bounds.height
            lab.frame = frame

            lab.center = CGPoint(x: lab.center.x, y: round(center.y - self.frame.minY))

            offset += lab.bounds.width + labelSpacing

            lab.isHidden = false
        }

        scrollView.contentOffset = CGPoint.zero
        scrollView.layer.removeAllAnimations()

        // If the label is bigger than the space allocated, then it should scroll
        if mainLabel.bounds.width > bounds.width {
            var size = CGSize(width: 0, height: 0)
            size.width = self.mainLabel.bounds.width + self.bounds.width + self.labelSpacing
            size.height = self.bounds.height
            self.scrollView.contentSize = size

            self.applyGradientMaskForFadeLength(fadeLengthIn: self.fadeLength, enableFade: self.scrolling)

            scrollLabelIfNeeded()
        } else {
            for lab in labels {
                lab.isHidden = lab != mainLabel
            }

            // Adjust the scroll view and main label
            self.scrollView.contentSize = self.bounds.size
            self.mainLabel.frame = self.bounds
            self.mainLabel.isHidden = false
            self.mainLabel.textAlignment = self.textAlignment

            // Cleanup animation
            scrollView.layer.removeAllAnimations()

            applyGradientMaskForFadeLength(fadeLengthIn: 0, enableFade: false)
        }

    }

    private func applyGradientMaskForFadeLength(fadeLengthIn: CGFloat, enableFade fade: Bool) {
        var fadeLength = fadeLengthIn

        let labelWidth = mainLabel.bounds.width
        if labelWidth <= self.bounds.width {
            fadeLength = 0
        }

        if fadeLength != 0 {
            gradientMaskFade(fade: fade)
        } else {
            layer.mask = nil
        }
    }

    func gradientMaskFade(fade: Bool) {
        // Recreate gradient mask with new fade length
        let gradientMask = CAGradientLayer()

        gradientMask.bounds = self.layer.bounds
        gradientMask.position = CGPoint(x: self.bounds.midX, y: self.bounds.midY)

        gradientMask.shouldRasterize = true
        gradientMask.rasterizationScale = UIScreen.main.scale

        gradientMask.startPoint = CGPoint(x: 0, y: self.frame.midY)
        gradientMask.endPoint = CGPoint(x: 1, y: self.frame.midY)

        // Setup fade mask colors and location
        let transparent = UIColor.clear.cgColor

        let opaque = UIColor.black.cgColor
        gradientMask.colors = [transparent, opaque, opaque, transparent]

        // Calcluate fade
        let fadePoint = fadeLength / self.bounds.width
        var leftFadePoint = fadePoint
        var rightFadePoint = 1 - fadePoint
        if !fade {
            switch (self.scrollDirection) {
            case .left:
                leftFadePoint = 0
            case .right:
                leftFadePoint = 0
                rightFadePoint = 1
            }
        }

        // Apply calculations to mask
        gradientMask.locations = [
            0,
            NSNumber(value: Double(leftFadePoint)),
            NSNumber(value: Double(rightFadePoint)),
            1
        ]

        // Don't animate the mask change
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.layer.mask = gradientMask
        CATransaction.commit()
    }

    private func onUIApplicationDidChangeStatusBarOrientationNotification(notification: NSNotification) {
        // Delay to have it re-calculate on next runloop
        perform(#selector(NeonScrollLabel.refreshLabels), with: nil, afterDelay: 0.1)
        perform(#selector(NeonScrollLabel.scrollLabelIfNeeded), with: nil, afterDelay: 0.1)
    }
}
#endif
