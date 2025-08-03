//
//  ImagesResponse.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

// MARK: -ImagesResponse-
struct ImagesResponse: Decodable {
    let backdrops: [BackdropsItem]
    
    init(backdrops: [BackdropsItem] = []) {
        self.backdrops = backdrops
    }
}

struct BackdropsItem: Decodable {
    let file_path: String
}
// MARK: -
