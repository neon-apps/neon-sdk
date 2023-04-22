//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 22.04.2023.
//

import Foundation
import UIKit

public class NeonHStack: UIStackView {
    var height: CGFloat = 0
    
    open override func addSubview(_ view: UIView) {
        super.addSubview(view)
        addArrangedSubview(view)
    }
    
    public convenience init(height: CGFloat, block: (NeonHStack) -> Void) {
          self.init()
          self.height = height
          block(self)
          commonInit()
      }
      
    
    private func commonInit() {
        spacing = 0
        axis = .horizontal
 
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        snp.makeConstraints { make in
            make.height.equalTo(height)
        }
    }
}
