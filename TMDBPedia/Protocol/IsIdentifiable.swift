//
//  IsIdentifiable.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/1/25.
//

import UIKit

protocol IsIdentifiable {
    static var identifier: String { get }
}

extension IsIdentifiable {
    static var identifier: String {
        String(describing: Self.self)
    }
}

extension UITableView {
    typealias TableViewCell = (UITableViewCell & IsIdentifiable)
    
    func register<T: TableViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: TableViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withIdentifier: cellClass.identifier, for: indexPath) as! T
    }
}

extension UICollectionView {
    typealias CollectionViewCell = (UICollectionViewCell & IsIdentifiable)
    
    func register<T: CollectionViewCell>(_ cellClass: T.Type) {
        self.register(cellClass, forCellWithReuseIdentifier: cellClass.identifier)
    }
    
    func dequeueReusableCell<T: CollectionViewCell>(_ cellClass: T.Type, for indexPath: IndexPath) -> T {
        self.dequeueReusableCell(withReuseIdentifier: cellClass.identifier, for: indexPath) as! T
    }
}
