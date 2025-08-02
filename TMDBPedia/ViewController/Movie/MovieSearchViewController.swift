//
//  MovieSearchViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

import UIKit
import Alamofire
import SnapKit
import Then

// MARK: -MovieSearchViewController-
final class MovieSearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private var movieInfo = SearchMovieResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}
// MARK: -Configure-
private extension MovieSearchViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureNavigation()
        configureTableView()
    }
    
    private func configureSubview() {
        view.addSubviews(searchBar, tableView)
    }
    
    private func configureLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview(\.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.height.equalTo(Constant.textFieldHeight)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .Background
        
        searchBar.do {
            $0.searchTextField.leftView?.tintColor = .Label
            $0.searchBarStyle = .minimal
        }
    }
    
    private func configureNavigation() {
        navigationItem.title = "영화 검색"
    }
}
// MARK: -Networking-
private extension MovieSearchViewController {
    private func callSearchMovieAPI(_ text: String) {
        let url = URL(string: APIURL.searchMovieURL)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
          URLQueryItem(name: "query", value: text),
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
            .responseDecodable(of: SearchMovieResponse.self) {
                switch $0.result {
                case .success(let searhMovieResponse):
                    self.handleSuccess(searhMovieResponse)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func handleSuccess(_ response: SearchMovieResponse) {
        print(response)
    }
}
// MARK: -TableView-
extension MovieSearchViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
}
// MARK: -
