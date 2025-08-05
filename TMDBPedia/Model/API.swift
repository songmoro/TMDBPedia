//
//  API.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/5/25.
//

import Foundation
import Alamofire

struct APIErrorReason: Error {
    enum Kind {
        case responseFailed
        case responseFailedWithError
        case responseFailedWithUnknownReason
    }
    
    let kind: Kind
    let statusCode: Int
    let errorResponse: Decodable?
    
    init(kind: Kind, statusCode: Int, errorResponse: Decodable? = nil) {
        self.kind = kind
        self.statusCode = statusCode
        self.errorResponse = errorResponse
    }
}

protocol API: URLRequestConvertible {
    
}
