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
    private let emptyLabel = UILabel()
    
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
        configureSearchBar()
    }
    
    private func configureSubview() {
        view.addSubviews(searchBar, tableView, emptyLabel)
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
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .Background
        
        searchBar.do {
            $0.searchTextField.leftView?.tintColor = .Label
            $0.searchBarStyle = .minimal
        }
        
        emptyLabel.do {
            $0.text = "원하는 검색결과를 찾지 못했습니다"
            $0.isHidden = true
        }
    }
    
    private func configureNavigation() {
        navigationItem.title = "영화 검색"
    }
}
// MARK: -SearchBar-
extension MovieSearchViewController: UITextFieldDelegate {
    private func configureSearchBar() {
        searchBar.searchTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSearchTextFieldReturn(textField)
        return true
    }
    
    private func handleSearchTextFieldReturn(_ textField: UITextField) {
        let text = textField.text!
        callSearchMovieAPI(text) {
            if $0.results.isEmpty {
                self.emptyLabel.isHidden = false
                self.tableView.isHidden = true
            }
            else {
                self.emptyLabel.isHidden = true
                self.tableView.isHidden = false
                self.handleSuccess($0)
            }
        }
    }
}
// MARK: -Networking-
private extension MovieSearchViewController {
    private func callSearchMovieAPI(_ text: String, handler: @escaping (SearchMovieResponse) -> Void) {
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
                    handler(searhMovieResponse)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func handleSuccess(_ response: SearchMovieResponse) {
        movieInfo = response
        tableView.reloadData()
    }
}
// MARK: -TableView-
extension MovieSearchViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchMovieCell.self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movieInfo.results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SearchMovieCell.self, for: indexPath)
        
        let item = movieInfo.results[indexPath.row]
        cell.input(item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        let item = movieInfo.results[indexPath.row]
        vc.input(item)
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
// MARK: -
