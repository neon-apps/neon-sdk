//
//  File.swift
//  
//
//  Created by Tuna Öztürk on 28.10.2023.
//

import Foundation

extension Array where Element: Equatable {
    mutating public func remove(_ item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
    
    mutating public func remove<T: Equatable>(_ item: Element, matching keyPath: KeyPath<Element, T>) {
        if let index = self.firstIndex(where: { $0[keyPath: keyPath] == item[keyPath: keyPath] }) {
            self.remove(at: index)
        }
    }
}
