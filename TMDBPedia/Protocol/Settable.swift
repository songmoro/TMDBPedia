//
//  Settable.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/8/25.
//


public protocol Settable { }

extension Array: Settable {
    func set<V>(_ to: ReferenceWritableKeyPath<Self.Element, V>, _ be: V) {
        for i in self.indices {
            self[i][keyPath: to] = be
        }
    }
}
