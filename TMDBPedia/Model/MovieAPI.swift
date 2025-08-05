//
//  MovieAPI.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/5/25.
//

import Foundation
import Alamofire

enum MovieAPI: API {
    case trending
    case images(id: Int)
    case credit(id: Int)
    case search(text: String, page: Int)
}

extension MovieAPI {
    private var baseURL: URL {
        guard let url = URL(string: APIURL.baseURL) else { fatalError("URL is invalid") }
        return url
    }
    
    private var path: String {
        return switch self {
        case .trending:
            APIURL.trendingPath
        case .images(let id):
            APIURL.moviePath + "/\(id)" + APIURL.imagesPostPath
        case .credit(let id):
            APIURL.moviePath + "/\(id)" + APIURL.creditPostPath
        case .search:
            APIURL.searchPath
        }
    }
    
    private var method: HTTPMethod {
        return .get
    }
    
    private var headers: HTTPHeaders {
        HTTPHeaders([
            "accept": "application/json",
            "Authorization": "Bearer \(APIKey.tmdbToken)"
        ])
    }
    
    private var parameters: Parameters? {
        switch self {
        case .trending:
            ["language": "ko-KR", "page": 1]
        case .images: nil
        case .credit:
            ["language": "ko-KR"]
        case .search(let text, let page):
            ["query": text, "language": "ko-KR", "include_adult": false, "page": page]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        urlRequest.method = method
        urlRequest.headers = headers
        
        if let parameters {
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
}
