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
    public var scrollView = UIScrollView()
    public let mainStack = UIStackView()
    public var padding = UIEdgeInsets.zero{
        didSet{
            applyPadding()
        }
    }
    // MARK: - View Lifecycle
    open override func viewDidLoad() {
        super.viewDidLoad()
        addMainStack()
    }
    // MARK: - UI Creation
    private func addMainStack() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(mainStack)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        mainStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.right.bottom.left.equalToSuperview()
        }
        mainStack.axis = .vertical
        mainStack.spacing = 20
    }
    func applyPadding(){
        mainStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        mainStack.isLayoutMarginsRelativeArrangement = true
        mainStack.snp.remakeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.top.bottom.equalToSuperview()
            
        }
    }
}
// MARK: - Spacing Functions

// MARK: - Spacing Functions


