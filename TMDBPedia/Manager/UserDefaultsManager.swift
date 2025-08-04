//
//  UserDefaultsManager.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/4/25.
//

import Foundation

final class UserDefaultsManager {
    private init() { }
    public static let shared = UserDefaultsManager()
    
    private let standard = UserDefaults.standard
    
    enum Key: String {
        case nickname
        case keywords
        case likeList
    }
    
    func get(_ key: Key) -> Any? {
        return standard.value(forKey: key.rawValue)
    }
    
    func getArray(_ key: Key) -> [Any]? {
        return standard.array(forKey: key.rawValue)
    }
    
    func set(_ key: Key, to newValue: Any?) {
        standard.set(newValue, forKey: key.rawValue)
    }
}
