//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 3.04.2023.
//

import Foundation
import UIKit

class NeonCollectionView<T, Cell: NeonCollectionViewCell<T>>: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var objects = [T]() {
           didSet {
               reloadData()
           }
       }
    var itemsPerRow: Int = 2 {
        didSet {
            collectionViewLayout.invalidateLayout()
        }
    }
    var leftPadding: CGFloat = 20
    var rightPadding: CGFloat = 20
    var horizontalItemSpacing: CGFloat = 20 {
        didSet {
            collectionViewLayout.invalidateLayout()
        }
    }
    
    var verticalItemSpacing: CGFloat = 20 {
        didSet {
            collectionViewLayout.invalidateLayout()
        }
    }

    var didSelect: ((T, IndexPath) -> Void)?
    private let cellReuseIdentifier = String(describing: Cell.self)
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        self.dataSource = self
        self.delegate = self
        self.register(Cell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! Cell
        let object = objects[indexPath.row]
        cell.configure(with: object)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        didSelect?(object, indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = horizontalItemSpacing
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = (collectionViewWidth - leftPadding - rightPadding - padding * CGFloat(itemsPerRow - 1)) / CGFloat(itemsPerRow)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: leftPadding, bottom: 10, right: rightPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return horizontalItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return verticalItemSpacing
      }
      
}

protocol ConfigurableCell {
    associatedtype ObjectType
    func configure(with data: ObjectType)
}

class NeonCollectionViewCell<T>: UICollectionViewCell {
    var configureCell: ((T) -> Void)?
    
    func configure(with object: T) {
        configureCell?(object)
    }
}
