//
//  TodayMovieResponse.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

struct TodayMovieResponse: Decodable {
    let results: [TodayMovieItem]
    
    init(results: [TodayMovieItem] = []) {
        self.results = results
    }
}

struct TodayMovieItem: Decodable {
    let id: Int
    let title: String
    let release_date: String
    let vote_average: Float
    let genre_ids: [Int]
    let poster_path: String
    let overview: String
}
