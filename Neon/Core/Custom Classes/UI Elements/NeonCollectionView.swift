//
//  File.swift
//
//
//  Created by Tuna Öztürk on 3.04.2023.
//
//
import Foundation
import UIKit


open class NeonCollectionView<T, Cell: NeonCollectionViewCell<T>>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var objects: [T] {
        didSet {
            reloadData()
        }
    }
    
    var itemsPerRow: Int
    var leftPadding: CGFloat
    var rightPadding: CGFloat
    var horizontalItemSpacing: CGFloat
    var verticalItemSpacing: CGFloat
    
    var didSelect: ((T, IndexPath) -> Void)?
    
    private let cellReuseIdentifier = String(describing: Cell.self)
    
    init(objects: [T] = [], itemsPerRow: Int = 2, leftPadding: CGFloat = 20, rightPadding: CGFloat = 20, horizontalItemSpacing: CGFloat = 20, verticalItemSpacing: CGFloat = 20) {
        self.objects = objects
        self.itemsPerRow = itemsPerRow
        self.leftPadding = leftPadding
        self.rightPadding = rightPadding
        self.horizontalItemSpacing = horizontalItemSpacing
        self.verticalItemSpacing = verticalItemSpacing
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        self.register(Cell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! Cell
        let object = objects[indexPath.row]
        cell.configure(with: object)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        didSelect?(object, indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = horizontalItemSpacing
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = (collectionViewWidth - leftPadding - rightPadding - padding * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: leftPadding, bottom: 10, right: rightPadding)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return horizontalItemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return verticalItemSpacing
    }
}

protocol ConfigurableCell {
    associatedtype ObjectType
    func configure(with data: ObjectType)
}

open class NeonCollectionViewCell<T>: UICollectionViewCell {
    
    public  var configureCell: ((T) -> Void)?
    
    public func configure(with object: T) {
        configureCell?(object)
    }
}

