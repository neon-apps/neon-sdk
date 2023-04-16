//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 16.04.2023.
//

import Foundation
import UIKit

/// VisualEffectView is a dynamic background blur view.
open class NeonBlurView: UIVisualEffectView {
    
    /// Returns the instance of UIBlurEffect.
    private let blurEffect = (NSClassFromString("_UICustomBlurEffect") as! UIBlurEffect.Type).init()
    
    /**
     Tint color.
     
     The default value is nil.
     */
    open var colorTint: UIColor? {
        get {
            if #available(iOS 14, *) {
                return ios14_colorTint
            } else {
                return _value(forKey: .colorTint)
            }
        }
        set {
            if #available(iOS 14, *) {
                ios14_colorTint = newValue
            } else {
                _setValue(newValue, forKey: .colorTint)
            }
        }
    }
    
    /**
     Tint color alpha.
     Don't use it unless `colorTint` is not nil.
     The default value is 0.0.
     */
    open var colorTintAlpha: CGFloat {
        get { return _value(forKey: .colorTintAlpha) ?? 0.0 }
        set {
            if #available(iOS 14, *) {
                ios14_colorTint = ios14_colorTint?.withAlphaComponent(newValue)
            } else {
                _setValue(newValue, forKey: .colorTintAlpha)
            }
        }
    }
    
    /**
     Blur radius.
     
     The default value is 0.0.
     */
    open var blurRadius: CGFloat {
        get {
            if #available(iOS 14, *) {
                return ios14_blurRadius
            } else {
                return _value(forKey: .blurRadius) ?? 0.0
            }
        }
        set {
            if #available(iOS 14, *) {
                ios14_blurRadius = newValue
            } else {
                _setValue(newValue, forKey: .blurRadius)
            }
        }
    }
    
    /**
     Scale factor.
     
     The scale factor determines how content in the view is mapped from the logical coordinate space (measured in points) to the device coordinate space (measured in pixels).
     
     The default value is 1.0.
     */
    open var scale: CGFloat {
        get { return _value(forKey: .scale) ?? 1.0 }
        set { _setValue(newValue, forKey: .scale) }
    }
    
    // MARK: - Initialization
    
    public override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        scale = 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        scale = 1
    }
    
}

// MARK: - Helpers
private extension NeonBlurView {
    
    /// Returns the value for the key on the blurEffect.
    func _value<T>(forKey key: Key) -> T? {
        return blurEffect.value(forKeyPath: key.rawValue) as? T
    }
    
    /// Sets the value for the key on the blurEffect.
    func _setValue<T>(_ value: T?, forKey key: Key) {
        blurEffect.setValue(value, forKeyPath: key.rawValue)
        if #available(iOS 14, *) {} else {
            self.effect = blurEffect
        }
    }
    
    enum Key: String {
        case colorTint, colorTintAlpha, blurRadius, scale
    }
    
}


@available(iOS 14, *)
extension UIVisualEffectView {
    var ios14_blurRadius: CGFloat {
        get {
            return gaussianBlur?.requestedValues?["inputRadius"] as? CGFloat ?? 0
        }
        set {
            prepareForChanges()
            gaussianBlur?.requestedValues?["inputRadius"] = newValue
            applyChanges()
        }
    }
    var ios14_colorTint: UIColor? {
        get {
            return sourceOver?.value(forKeyPath: "color") as? UIColor
        }
        set {
            prepareForChanges()
            sourceOver?.setValue(newValue, forKeyPath: "color")
            sourceOver?.perform(Selector(("applyRequestedEffectToView:")), with: overlayView)
            applyChanges()
            overlayView?.backgroundColor = newValue
        }
    }
}

private extension UIVisualEffectView {
    var backdropView: UIView? {
        return subview(of: NSClassFromString("_UIVisualEffectBackdropView"))
    }
    var overlayView: UIView? {
        return subview(of: NSClassFromString("_UIVisualEffectSubview"))
    }
    var gaussianBlur: NSObject? {
        return backdropView?.value(forKey: "filters", withFilterType: "gaussianBlur")
    }
    var sourceOver: NSObject? {
        return overlayView?.value(forKey: "viewEffects", withFilterType: "sourceOver")
    }
    func prepareForChanges() {
        self.effect = UIBlurEffect(style: .light)
        gaussianBlur?.setValue(1.0, forKeyPath: "requestedScaleHint")
    }
    func applyChanges() {
        backdropView?.perform(Selector(("applyRequestedFilterEffects")))
    }
}

private extension NSObject {
    var requestedValues: [String: Any]? {
        get { return value(forKeyPath: "requestedValues") as? [String: Any] }
        set { setValue(newValue, forKeyPath: "requestedValues") }
    }
    func value(forKey key: String, withFilterType filterType: String) -> NSObject? {
        return (value(forKeyPath: key) as? [NSObject])?.first { $0.value(forKeyPath: "filterType") as? String == filterType }
    }
}

private extension UIView {
    func subview(of classType: AnyClass?) -> UIView? {
        return subviews.first { type(of: $0) == classType }
    }
}
