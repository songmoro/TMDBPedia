//
//  HTTPURLResponse+Optional+.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/5/25.
//

import Foundation

enum HTTPURLResponseErrorReason: Error {
    case responseIsNil
}

extension HTTPURLResponse? {
    func unwrapped() throws -> HTTPURLResponse {
        guard let self = self else { throw HTTPURLResponseErrorReason.responseIsNil }
        return self
    }
}
