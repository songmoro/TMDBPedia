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
// MARK: -Validation-
extension Nickname {
    static func validateNickname(text: String?) -> Result<Nickname, NicknameError> {
        guard let text else {
            return .failure(NicknameError(text: nil, kind: .textIsNil))
        }
        guard 2..<10 ~= text.count else {
            return .failure(NicknameError(text: text, kind: .invalidRange))
        }
        guard !text.contains(where: \.isNumber) else {
            return .failure(NicknameError(text: text, kind: .containsNumber))
        }
        guard !text.contains(where: isLimitedSymbol) else {
            return .failure(NicknameError(text: text, kind: .containsSpecialSymbol))
        }
        
        return .success(Nickname(text: text))
    }
    
    private static func isLimitedSymbol(_ character: Character) -> Bool {
        return "@#$%".contains(character)
    }
}
// MARK: -
