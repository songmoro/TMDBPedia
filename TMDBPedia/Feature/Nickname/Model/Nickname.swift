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
// MARK: -Validation-
extension Nickname {
    func validateNickname() throws(NicknameError) {
        guard 2..<10 ~= text.count else {
            throw NicknameError(text: text, kind: .invalidRange)
        }
        guard !text.contains(where: \.isNumber) else {
            throw NicknameError(text: text, kind: .containsNumber)
        }
        guard !text.contains(where: isLimitedSymbol) else {
            throw NicknameError(text: text, kind: .containsSpecialSymbol)
        }
    }
    
    private func isLimitedSymbol(_ character: Character) -> Bool {
        return "@#$%".contains(character)
    }
}
// MARK: -
