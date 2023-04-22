//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 22.04.2023.
//

import Foundation
import UIKit
import SnapKit

open class NeonViewController: UIViewController {
    
    // MARK: - Properties
    
    fileprivate let scrollView = UIScrollView()
    public let mainStack = UIStackView()
    
    // MARK: - View Lifecycle
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        addMainStack()
    }
    
    // MARK: - UI Creation
    
    private func addMainStack() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(mainStack)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        mainStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view.snp.width)
        }
        mainStack.axis = .vertical
        mainStack.spacing = 20
    }
    
    // MARK: - Spacing Functions
    
}
