//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 3.04.2023.
//

import Foundation
import UIKit


public struct SwipeAction<T> {
    let title: String
    let color: UIColor
    let action: (T, IndexPath) -> Void
    
    public init(title: String, color: UIColor, action: @escaping (T, IndexPath) -> Void) {
        self.title = title
        self.color = color
        self.action = action
    }
}


open class NeonTableView<T, Cell: NeonTableViewCell<T>>: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    public var objects: [T] {
        didSet {
            reloadData()
        }
    }
    
    public var didSelect: ((T, IndexPath) -> Void)?
    private let cellReuseIdentifier = String(describing: Cell.self)
    public var trailingSwipeActions = [SwipeAction<T>]()
    public var leadingSwipeActions = [SwipeAction<T>]()
    
    public init(objects: [T] = []) {
        self.objects = objects
        super.init(frame: .zero, style: .plain)
        self.dataSource = self
        self.delegate = self
        self.register(Cell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.separatorStyle = .none
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! Cell
        let object = objects[indexPath.row]
        cell.configure(with: object)
        cell.selectionStyle = .none
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = objects[indexPath.row]
        didSelect?(object, indexPath)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.separatorStyle = .none // Update separator style on layoutSubviews
    }
    
    public func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         return configureSwipeActions(for: indexPath, swipeActions: leadingSwipeActions)
     }
     
     public func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         return configureSwipeActions(for: indexPath, swipeActions: trailingSwipeActions)
     }
     
     private func configureSwipeActions(for indexPath: IndexPath, swipeActions: [SwipeAction<T>]) -> UISwipeActionsConfiguration? {
         var actions = [UIContextualAction]()
         for swipeAction in swipeActions where swipeAction.color != .clear {
             let action = UIContextualAction(style: .normal, title: swipeAction.title) { [weak self] (action, view, completionHandler) in
                 guard let self = self else { return }
                 let object = self.objects[indexPath.row]
                 swipeAction.action(object, indexPath)
                 completionHandler(true)
             }
             action.backgroundColor = swipeAction.color
             actions.append(action)
         }
         
         let configuration = UISwipeActionsConfiguration(actions: actions)
         configuration.performsFirstActionWithFullSwipe = false
         return configuration
     }
    
}

open class NeonTableViewCell<T>: UITableViewCell, ConfigurableCell {
    
    public var configureCell: ((T) -> Void)?
    
    public func configure(with object: T) {
        configureCell?(object)
    }
}
