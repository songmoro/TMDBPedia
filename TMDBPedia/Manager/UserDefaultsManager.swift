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
        case test
    }
    
    func getArray(_ key: Key) -> [Any]? {
        return standard.array(forKey: key.rawValue)
    }
    
    func set(_ key: Key, to newValue: Any?) {
        standard.set(newValue, forKey: key.rawValue)
    }
    
    func getObject<T: Decodable>(of type: T.Type = T.self, _ key: Key) -> T? {
        if let data = standard.data(forKey: key.rawValue) {
            return try? PropertyListDecoder().decode(T.self, from: data)
        }
        return nil
    }
    
    func setObject<T: Encodable>(_ key: Key, to newValue: T?) {
        standard.set(try? PropertyListEncoder().encode(newValue), forKey: key.rawValue)
    }
    
    func remove(_ key: Key) {
        standard.set(nil, forKey: key.rawValue)
    }
}
