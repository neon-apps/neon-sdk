//
//  NeonBasePageControl.swift
//  NeonPageControl  
//


import UIKit

@IBDesignable open class NeonBasePageControl: UIControl, NeonPageControllable {
    
    open weak var delegate: NeonBasePageControlDelegate?

    @IBInspectable open var numberOfPages: Int = 0 {
        didSet {
            populateTintColors()
            updateNumberOfPages(numberOfPages)
            self.isHidden = hidesForSinglePage && numberOfPages <= 1
        }
    }
    
    @IBInspectable open var progress: Double = 0 {
        didSet {
            update(for: progress)
        }
    }
    
    open var currentPage: Int {
        return Int(round(progress))
    }
    
    
    @IBInspectable open var padding: CGFloat = 5 {
        didSet {
            setNeedsLayout()
            update(for: progress)
        }
    }
    
    @IBInspectable open var radius: CGFloat = 10 {
        didSet {
            setNeedsLayout()
            update(for: progress)
        }
    }
    
    @IBInspectable open var inactiveTransparency: CGFloat = 0.4 {
        didSet {
            setNeedsLayout()
            update(for: progress)
        }
    }
    
    @IBInspectable open var hidesForSinglePage: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var borderWidth: CGFloat = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    override open var tintColor: UIColor! {
        didSet {
            setNeedsLayout()
        }
    }
    
    open var tintColors: [UIColor] = [] {
        didSet {
            guard tintColors.count == numberOfPages else {
                fatalError("The number of tint colors needs to be the same as the number of page")
            }
            setNeedsLayout()
        }
    }

    @IBInspectable open var currentPageTintColor: UIColor? {
        didSet {
            setNeedsLayout()
        }
    }

    internal var moveToProgress: Double?
    
    private var displayLink: CADisplayLink?
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupDisplayLink()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupDisplayLink()
    }
    
    internal func setupDisplayLink() {
        self.displayLink = CADisplayLink(target: WeakProxy(self), selector: #selector(updateFrame))
        self.displayLink?.add(to: .current, forMode: .common)
    }

    @objc internal func updateFrame() {
        self.animate()
    }
    
    open func set(progress: Int, animated: Bool) {
        guard progress <= numberOfPages - 1 && progress >= 0 else { return }
        if animated == true {
            self.moveToProgress = Double(progress)
        } else {
            self.progress = Double(progress)
        }
    }
    
    func tintColor(position: Int) -> UIColor {
        if tintColors.count < numberOfPages {
            return tintColor
        } else {
            return tintColors[position]
        }
    }
    
    open func insertTintColor(_ color: UIColor, position: Int) {
        if tintColors.count < numberOfPages {
            setupTintColors()
        }
        tintColors[position] = color
    }
    
    private func setupTintColors() {
        tintColors = Array<UIColor>(repeating: tintColor, count: numberOfPages)
    }
    
    private func populateTintColors() {
        guard tintColors.count > 0 else { return }
        
        if tintColors.count > numberOfPages {
            tintColors = Array(tintColors.prefix(numberOfPages))
        } else if tintColors.count < numberOfPages {
            tintColors.append(contentsOf: Array<UIColor>(repeating: tintColor, count: numberOfPages - tintColors.count))
        }
    }
    
    private var tapEvent: UITapGestureRecognizer?
    @IBInspectable open var enableTouchEvents: Bool = false {
        didSet {
            enableTouchEvents ? enableTouch() : disableTouch()
        }
    }
    
    private func enableTouch() {
        if tapEvent == nil {
            setupTouchEvent()
        }
    }
    
    private func disableTouch() {
        if tapEvent != nil {
            removeGestureRecognizer(tapEvent!)
            tapEvent = nil
        }
    }
    
    internal func setupTouchEvent() {
        tapEvent = UITapGestureRecognizer(target: self, action: #selector(self.didTouch(gesture:)))
        addGestureRecognizer(tapEvent!)
    }
    
    @objc internal func didTouch(gesture: UITapGestureRecognizer) {}
    
    func animate() {
        guard let moveToProgress = self.moveToProgress else { return }
        
        let a = fabsf(Float(moveToProgress))
        let b = fabsf(Float(progress))
        
        if a > b {
            self.progress += 0.1
        }
        if a < b {
            self.progress -= 0.1
        }
        
        if a == b {
            self.progress = moveToProgress
            self.moveToProgress = nil
        }
        
        if self.progress < 0 {
            self.progress = 0
            self.moveToProgress = nil
        }
        
        if self.progress > Double(numberOfPages - 1) {
            self.progress = Double(numberOfPages - 1)
            self.moveToProgress = nil
        }
    }
    
    func updateNumberOfPages(_ count: Int) {
        fatalError("Should be implemented in child class")
    }
    
    func update(for progress: Double) {
        fatalError("Should be implemented in child class")
    }

    deinit {
        self.displayLink?.remove(from: .current, forMode: .common)
        self.displayLink?.invalidate()
    }
}

extension NeonBasePageControl {
    internal func blend(color1: UIColor, color2: UIColor, progress: CGFloat) -> UIColor {
        let l1 = 1 - progress
        let l2 = progress
        var (r1, g1, b1, a1): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        var (r2, g2, b2, a2): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
        
        color1.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
        color2.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
        
        return UIColor(red: l1*r1 + l2*r2, green: l1*g1 + l2*g2, blue: l1*b1 + l2*b2, alpha: l1*a1 + l2*a2)
    }
}

public protocol NeonBasePageControlDelegate: AnyObject {
    func didTouch(pager: NeonBasePageControl, index: Int)
}

final class WeakProxy: NSObject {
    weak var target: NSObjectProtocol?

    init(_ target: NSObjectProtocol) {
        self.target = target
        super.init()
    }

    override func responds(to aSelector: Selector!) -> Bool {
        guard let target = target else { return super.responds(to: aSelector) }
        return target.responds(to: aSelector)
    }

    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        return target
    }
}
