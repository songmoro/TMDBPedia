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
    
    func getArray(_ key: Key) -> [Any]? {
        return standard.array(forKey: key.rawValue)
    }
    
    func set(_ key: Key, to newValue: Any?) {
        standard.set(newValue, forKey: key.rawValue)
    }
    
    func getObject<T: Decodable>(of type: T.Type = T.self, _ key: Key) -> T? {
        if let data = standard.data(forKey: key.rawValue) {
            if key == .keywords {
                let value: [Keyword]? = try? PropertyListDecoder().decode([Keyword].self, from: data)
                
                if let value {
                    return value.sorted(by: { $0.date > $1.date }) as? T
                }
            }
            else {
                return try? PropertyListDecoder().decode(T.self, from: data)
            }
        }
        
        return nil
    }
    
    func setObject<T: Encodable>(_ key: Key, to newValue: T?) {
        switch key {
        case .keywords:
            if var newValue = newValue as? [Keyword] {
                newValue = Set(newValue).sorted { $0.date > $1.date }
                standard.set(try? PropertyListEncoder().encode(newValue), forKey: key.rawValue)
            }
            else {
                remove(key)
            }
        default:
            standard.set(try? PropertyListEncoder().encode(newValue), forKey: key.rawValue)
        }
    }
    
    func remove(_ key: Key) {
        standard.set(nil, forKey: key.rawValue)
    }
}
