//
//  NeonNumericTextfield.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 12.11.2023.
//

import UIKit
import SnapKit


public protocol NeonNumericTextfieldDelegate: AnyObject {
    func digitsDidFinish(_ NeonNumericTextfield: NeonNumericTextfield)
    func digitsDidChange(_ NeonNumericTextfield: NeonNumericTextfield)
}

public extension NeonNumericTextfieldDelegate {
    func digitsDidChange(_: NeonNumericTextfield) {}
}

public class NeonNumericTextfield: UIView {
    public enum DigitCornerStyle: Equatable {
           case circle, radius(CGFloat)
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = spacing
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .equalSpacing
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.alpha = 0
        textField.borderStyle = .none
        if #available(iOS 12.0, *) {
            textField.textContentType = .oneTimeCode
        }
        
        if #available(iOS 10.0, *) {
            textField.keyboardType = .asciiCapableNumberPad
        } else {
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textField.delegate = self
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textFieldDidChange),
            name: UITextField.textDidChangeNotification,
            object: nil
        )
        return textField
    }()
    
    /// The number of digits drawn in the view
    public var numberOfDigits: Int = 6 {
        didSet {
            setupLabels()
        }
    }
    public var numberOfFilledDigits: Int = 0
    
    /// font of each digit
    public var digitFont: UIFont = .systemFont(ofSize: 17) {
        didSet {
            labels.forEach { $0.font = digitFont }
        }
    }
    
    /// borderColor of each digit
    public var digitBorderColor: UIColor = UIColor.lightGray.withAlphaComponent(0.5) {
        didSet {
            labels.forEach { $0.layer.borderColor = digitBorderColor.cgColor }
        }
    }
    
    /// borderColor of each digit
    public var nextDigitBorderColor: UIColor = UIColor.blue {
        didSet {
            textFieldDidChange()
        }
    }
    
    // borderWidth of each digit
    public var digitColor: UIColor = UIColor.black {
        didSet {
            labels.forEach { $0.textColor = digitColor }
        }
    }
    
    
    /// borderWidth of each digit
    public var digitBorderWidth: CGFloat = 1 {
        didSet {
            labels.forEach { $0.layer.borderWidth = digitBorderWidth }
        }
    }
    
    /// cornerRadius of each digits
    public var digitCornerStyle: DigitCornerStyle = .radius(15) {
        didSet {
            setupLabels()
        }
    }
    
    private var labels = [UILabel]() {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            labels.forEach { stackView.addArrangedSubview($0) }
        }
    }
    
    /// The distance between digits
    private var spacing: CGFloat = 16 {
        didSet { stackView.spacing = spacing }
    }
    
    public var text: String {
        get { textField.text! }
        set {
            textField.text = newValue
            textFieldDidChange()
        }
    }
    
    public weak var delegate: NeonNumericTextfieldDelegate?
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        [textField, stackView].forEach {
            addSubview($0)
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: topAnchor),
                $0.leadingAnchor.constraint(equalTo: leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: trailingAnchor),
                $0.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
        
        setupLabels()
        
        addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(becomeFirstResponder)))
    }
    
    private func setupLabels() {
        stackView.alignment = digitCornerStyle == .circle ? .center : .fill
        stackView.distribution = digitCornerStyle == .circle ? .equalSpacing : .fillEqually
        
        // create all labels
        labels = (1 ... numberOfDigits).map { index in
            let label = UILabel()
            label.textAlignment = .center
            
            label.font = digitFont
            label.textColor = digitColor
            label.layer.allowsEdgeAntialiasing = true
            label.layer.borderWidth = digitBorderWidth
            
            label.layer.borderColor = digitBorderColor.cgColor
            label.layer.borderColor = index == 1 ? nextDigitBorderColor.cgColor : digitBorderColor.cgColor
            
            label.translatesAutoresizingMaskIntoConstraints = false
            
            return label
        }
        
        if digitCornerStyle == .circle {
            let widthFactor = CGFloat(1.0) / CGFloat(numberOfDigits)
            labels.forEach {
                NSLayoutConstraint.activate([
                    $0.widthAnchor.constraint(equalTo: $0.heightAnchor, multiplier: 1.0),
                    $0.heightAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: widthFactor, constant: -spacing)
                ])
            }
        }
        
        labels.forEach {
            $0.layoutIfNeeded()
            switch digitCornerStyle {
            case .circle: $0.layer.cornerRadius = $0.bounds.width / 2
            case .radius(let value): $0.layer.cornerRadius = value
            }
        }
    }
    
    public override func layoutSubviews() {
        labels.forEach {
            $0.layoutIfNeeded()
            switch digitCornerStyle {
            case .circle: $0.layer.cornerRadius = $0.bounds.width / 2
            case .radius(let value): $0.layer.cornerRadius = value
            }
        }
        
        super.layoutSubviews()
    }
    
    @discardableResult public override func becomeFirstResponder() -> Bool {
        textField.becomeFirstResponder()
    }
    
    @discardableResult public override func resignFirstResponder() -> Bool {
        textField.resignFirstResponder()
    }
}

extension NeonNumericTextfield: UITextFieldDelegate {
    @objc private func textFieldDidChange() {
        guard !labels.isEmpty else { return }
        
        labels.forEach {
            $0.text = ""
            $0.layer.borderColor = digitBorderColor.cgColor
        }
        
        textField.text!.enumerated().forEach { index, character in
            labels[index].text = "\(character)"
        }
        
        if text.isEmpty {
            labels[0].layer.borderColor = nextDigitBorderColor.cgColor
        } else if text.count < numberOfDigits {
            labels[text.count].layer.borderColor = nextDigitBorderColor.cgColor
        }
        
        numberOfFilledDigits = text.count
        if text.count == numberOfDigits {
            delegate?.digitsDidFinish(self)
        }
        
        delegate?.digitsDidChange(self)
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        if !string.isEmpty, textField.text!.count == numberOfDigits {
            return false
        }
        
        return true
    }
}
