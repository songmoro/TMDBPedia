//
//  UserDefaultsManager.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/4/25.
//

import Foundation
import Combine

final class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    
    private enum Key: String {
        case keywords
        case nickname
        case likeList
    }
    
    private init() {
        let keywordsData = UserDefaults.standard.data(forKey: Key.keywords.rawValue)
        
        if let keywordsData {
            let value: [Keyword]? = try? PropertyListDecoder().decode([Keyword].self, from: keywordsData)
            self.keywords = value
        }
        else {
            self.keywords = []
        }
        
        let nicknameData = UserDefaults.standard.data(forKey: Key.nickname.rawValue)
        if let nicknameData {
            let value: Nickname? = try? PropertyListDecoder().decode(Nickname.self, from: nicknameData)
            self.nickname = value
        }
        else {
            self.nickname = nil
        }
        
        let likeList = UserDefaults.standard.array(forKey: Key.likeList.rawValue)
        if let likeList {
            let value: [Int]? = likeList as? [Int]
            self.likeList = value
        }
        else {
            self.likeList = []
        }
    }
    
    @Published var keywords: [Keyword]? {
        willSet {
            if let newValue {
                let newSortedValue = Set(newValue).sorted { $0.date > $1.date }
                UserDefaults.standard.set(try? PropertyListEncoder().encode(newSortedValue), forKey: Key.keywords.rawValue)
            }
            else {
                UserDefaults.standard.set(nil, forKey: Key.keywords.rawValue)
            }
        }
    }
    
    @Published var nickname: Nickname? {
        willSet {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(newValue), forKey: Key.nickname.rawValue)
        }
    }
    
    @Published var likeList: [Int]? {
        willSet {
            UserDefaults.standard.set(newValue, forKey: Key.likeList.rawValue)
        }
    }
    
    private(set) lazy var keywordsPublisher: AnyPublisher<[Keyword]?, Never> = $keywords.dropFirst().eraseToAnyPublisher()
    private(set) lazy var nicknamePublisher: AnyPublisher<Nickname?, Never> = $nickname.dropFirst().eraseToAnyPublisher()
    private(set) lazy var likeListPublisher: AnyPublisher<[Int]?, Never> = $likeList.dropFirst().eraseToAnyPublisher()
}
