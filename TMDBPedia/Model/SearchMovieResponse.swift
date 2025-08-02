//
//  SearchMovieResponse.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

struct SearchMovieResponse: Decodable {
    let results: [SearchMovieItem]
    
    init(results: [SearchMovieItem] = []) {
        self.results = results
    }
}

struct SearchMovieItem: Decodable {
    let id: Int
    let poster_path: String
    let title: String
    let release_date: String
    let genre_ids: [Int]
}
