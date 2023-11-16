//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 22.04.2023.
//

import Foundation
import UIKit
import SnapKit

extension UIStackView{
    
   public func addSpacer(_ size: CGFloat = 20) {
        let spacingView = UIView()
        spacingView.snp.makeConstraints { make in
            make.height.width.equalTo(size - self.spacing)
        }
        self.addArrangedSubview(spacingView)
    }
}
