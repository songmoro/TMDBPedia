//
//  CreditsResponse.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

// MARK: -CreditsResponse-
struct CreditsResponse: Decodable {
    let cast: [CreditsItem]
    
    init(cast: [CreditsItem] = []) {
        self.cast = cast
    }
}
// MARK: -CreditsItem-
struct CreditsItem: Decodable {
    let profile_path: String?
    let name: String
    let character: String
}
// MARK: -
