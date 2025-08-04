//
//  Nickname.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/4/25.
//

import Foundation

// MARK: -Nickname-
struct Nickname: Codable {
    var text: String
    let date: Date
    
    init(text: String, date: Date = Date()) {
        self.text = text
        self.date = date
    }
}
// MARK: -Access-
extension Nickname {
    static func get() -> Self? {
        UserDefaultsManager.shared.getObject(.nickname)
    }
    
    static func set(_ newNickname: String) {
        var nickname = get() ?? Nickname(text: newNickname)
        nickname.text = newNickname
        
        UserDefaultsManager.shared.setObject(.nickname, to: nickname)
    }
    
    static func remove() {
        UserDefaultsManager.shared.remove(.nickname)
    }
}
// MARK: -
