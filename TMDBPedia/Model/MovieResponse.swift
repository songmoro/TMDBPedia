//
//  MovieResponse.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

struct MovieResponse: Decodable {
    var page: Int
    let total_pages: Int
    let total_results: Int
    var results: [MovieItem]
    
    init(page: Int = 1, total_pages: Int = 0, total_results: Int = 0, results: [MovieItem] = []) {
        self.page = page
        self.total_pages = total_pages
        self.total_results = total_results
        self.results = results
    }
    
    func hasNextPage(_ row: Int) -> Bool {
        row == (results.count - 2) && total_results > (results.count + 20)
    }
}

struct MovieItem: Decodable {
    let id: Int
    let poster_path: String?
    let title: String
    let overview: String
    let vote_average: Float
    let release_date: String
    let genre_ids: [Int]
}
