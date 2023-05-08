//
//  File.swift
//
//
//  Created by Tuna Öztürk on 3.04.2023.
//
//
import Foundation
import UIKit




@available(iOS 13.0, *)
open class NeonCollectionView<T, Cell: NeonCollectionViewCell<T>>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public var contextMenuActions = [ContextMenuAction<T>]()
    
   public var objects: [T] {
        didSet {
            reloadData()
        }
    }
    
    public var itemsPerRow: Int?
    public var heightForItem : CGFloat?
    public var widthForItem : CGFloat?
    public var verticalItemSpacing: CGFloat?
    
    public var leftPadding: CGFloat
    public var rightPadding: CGFloat
    public var horizontalItemSpacing: CGFloat
   
    
    public var didSelect: ((T, IndexPath) -> Void)?
    
    private let cellReuseIdentifier = String(describing: Cell.self)
    
    /// Use this initalizer for vertical collections.
    public init(objects: [T] = [], itemsPerRow: Int = 2, leftPadding: CGFloat = 20, rightPadding: CGFloat = 20, horizontalItemSpacing: CGFloat = 20, verticalItemSpacing: CGFloat = 20, heightForItem : CGFloat? = nil) {
        self.objects = objects
        self.itemsPerRow = itemsPerRow
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.heightForItem = heightForItem
        self.horizontalItemSpacing = horizontalItemSpacing
        self.verticalItemSpacing = verticalItemSpacing
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        self.register(Cell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    /// Use this initalizer for horizontal collections.
    public init(objects: [T] = [], leftPadding: CGFloat = 20, rightPadding: CGFloat = 20, horizontalItemSpacing: CGFloat = 20 , widthForItem : CGFloat? = nil) {
        self.objects = objects
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.horizontalItemSpacing = horizontalItemSpacing
        self.widthForItem = widthForItem
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        self.register(Cell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! Cell
        let object = objects[indexPath.row]
        cell.configure(with: object)
        return cell
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        didSelect?(object, indexPath)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let itemsPerRow{
            let padding: CGFloat = horizontalItemSpacing
            let collectionViewWidth = collectionView.bounds.width
            let itemWidth = (collectionViewWidth - leftPadding - rightPadding - padding * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow)
            return CGSize(width: itemWidth, height: heightForItem ?? itemWidth)
        }
        
        if let widthForItem{
            let collectionViewHeight = collectionView.bounds.height
            return CGSize(width: widthForItem, height: collectionViewHeight)
        }
    
        fatalError("You need to specify itemsPerRow or widthForItem")
    
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: rightPadding)
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return horizontalItemSpacing
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return verticalItemSpacing ?? 0.0
    }
    
    open func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let object = objects[indexPath.row]
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] suggestedActions in
            var actions = [UIAction]()
            for contextMenuAction in self.contextMenuActions {
                var image: UIImage? = nil
                if let actionImage = contextMenuAction.image {
                    image = UIImage(systemName: actionImage)
                }
                let uiAction = UIAction(title: contextMenuAction.title, image: image, attributes: contextMenuAction.isDestructive ? .destructive : []) { action in
                    contextMenuAction.action(object, indexPath)
                }
                actions.append(uiAction)
            }
            return UIMenu(title: "", children: actions)
        }
        return configuration
    }
}

protocol ConfigurableCell {
    associatedtype ObjectType
    func configure(with data: ObjectType)
}

open class NeonCollectionViewCell<T>: UICollectionViewCell {
    
    open  var configureCell: ((T) -> Void)?
    
    open func configure(with object: T) {
        configureCell?(object)
    }
}

public struct ContextMenuAction<T> {
    let title: String
    let image: String?
    let action: (T, IndexPath) -> Void
    let isDestructive: Bool
    
    public init(title: String, imageSystemName: String? = nil, isDestructive: Bool = false, action: @escaping (T, IndexPath) -> Void) {
        self.title = title
        self.image = imageSystemName
        self.action = action
        self.isDestructive = isDestructive
    }
}
