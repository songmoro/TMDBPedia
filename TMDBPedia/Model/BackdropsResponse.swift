//
//  BackdropsResponse.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

// MARK: -BackdropsResponse-
struct BackdropsResponse: Decodable {
    let backdrops: [BackdropsItem]
}

struct BackdropsItem: Decodable {
    let file_path: String
}
// MARK: -
