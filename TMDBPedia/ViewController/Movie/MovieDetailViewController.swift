//
//  MovieDetailViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import Alamofire
import SnapKit
import Then

// MARK: -MovieDetailViewController-
final class MovieDetailViewController: UIViewController {
    private var tableView = UITableView()
    private var id: Int?
    private var synopsis: String?
    private var imagesInfo = ImagesResponse()
    private var creditsInfo = CreditsResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configreTableView()
    }
    
    private func configureSubview() {
        view.addSubview(tableView)
    }
    
    private func configureLayout() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        
    }
}
// MARK: -Open-
extension MovieDetailViewController {
    public func input(_ item: SearchMovieItem) {
        handleInput(item)
    }
    
    private func handleInput(_ item: SearchMovieItem) {
        self.id = item.id
        
        updateBackdrops(item.id)
        updateSynopsis(text: item.overview)
        callCreditsAPI(item.id)
    }
    
    private func updateBackdrops(_ id: Int) {
        let url = URL(string: APIURL.imagesURL(id))!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
//        let queryItems: [URLQueryItem] = [
//          URLQueryItem(name: "include_image_language", value: "ko"),
//        ]
//        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(APIKey.tmdbToken)"
        ]

        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: ImagesResponse.self) {
                switch $0.result {
                case .success(let imagesResponse):
                    self.imagesInfo = imagesResponse
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func updateSynopsis(text: String) {
        synopsis = text
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
    }
    
    private func callCreditsAPI(_ id: Int) {
        let url = URL(string: APIURL.creditsURL(id))!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "language", value: "ko-KR")
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
          "accept": "application/json",
          "Authorization": "Bearer \(APIKey.tmdbToken)"
        ]

        AF.request(request)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: CreditsResponse.self) {
                switch $0.result {
                case .success(let creditsResponse):
                    self.creditsInfo = creditsResponse
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
    }
}
// MARK: -TableView-
extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    private func configreTableView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(BackdropsCell.self)
            $0.register(SynopsisCell.self)
            $0.register(CastCell.self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else if section == 1 {
            return 1
        }
        else {
            return creditsInfo.cast.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            let item = imagesInfo.backdrops
            cell = tableView.dequeueReusableCell(BackdropsCell.self, for: indexPath).then {
                $0.input(item)
            }
        }
        else if indexPath.section == 1 {
            let item = synopsis ?? ""
            cell = tableView.dequeueReusableCell(SynopsisCell.self, for: indexPath).then {
                $0.input(item: item)
            }
        }
        else {
            let item = creditsInfo.cast[indexPath.row]
            cell = tableView.dequeueReusableCell(CastCell.self, for: indexPath).then {
                $0.input(item)
            }
        }
        
        return cell
    }
}
// MARK: -
