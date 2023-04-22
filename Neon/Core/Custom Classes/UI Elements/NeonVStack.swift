//
//  File 2.swift
//  
//
//  Created by Tuna Öztürk on 22.04.2023.
//

import Foundation
import UIKit

public class NeonVStack: UIStackView {
    var width: CGFloat = 0
    
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        addArrangedSubview(view)
    }
    
    public convenience init(width: CGFloat, block: (NeonVStack) -> Void) {
            self.init()
            self.width = width
            block(self)
            commonInit()
        }
    
    private func commonInit() {
        spacing = 0
        axis = .vertical
        distribution = .equalSpacing
        
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        snp.makeConstraints { make in
            make.width.equalTo(width)
        }
    }
}
