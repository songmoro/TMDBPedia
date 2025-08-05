//
//  Keyword.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/5/25.
//

import Foundation

struct Keyword: Codable {
    let text: String
    let date: Date
    
    init(text: String, date: Date = Date()) {
        self.text = text
        self.date = date
    }
}

extension Keyword: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
    
    static func ==(lhs: Keyword, rhs: Keyword) -> Bool {
        lhs.text == rhs.text
    }
}
