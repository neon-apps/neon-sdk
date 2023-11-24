//
//  NeonLongOnboardingSayGoodbyeView.swift
//  Quit Drinking
//
//  Created by Tuna Öztürk on 13.11.2023.
//

import Foundation
import UIKit
import NeonSDK

class NeonLongOnboardingSayGoodbyeView: UIImageView {

    private let label = UILabel()

    // Property to set the label text
    var labelText: String = "" {
        didSet {
            label.text = labelText
        }
    }
 
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Setup and layout the subviews
    private func setupViews() {
        self.contentMode = .scaleAspectFit
        

        
        addSubview(label)
        label.textColor = .white
        label.font = Font.custom(size: 18, fontWeight: .SemiBold)
        label.textAlignment = .center
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }
    
    func rotate(degree : CGFloat){
        let rotationAngle = degree * CGFloat.pi / 180
        self.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
}
