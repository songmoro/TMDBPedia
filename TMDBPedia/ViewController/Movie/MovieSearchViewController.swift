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

final class SearchMovieCell: UITableViewCell, IsIdentifiable {
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
//    let genreLables = [UILabel]()
    let likeButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        contentView.addSubviews(posterImageView, titleLabel, dateLabel, likeButton)
    }
    
    private func configureLayout() {
        posterImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview().inset(Constant.offsetFromHorizon).priority(1000)
            $0.width.equalToSuperview().multipliedBy(0.25).priority(999)
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.25)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(Constant.offsetFromHorizon)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.offsetFromTop)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(Constant.offsetFromHorizon)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
    
    private func configureView() {
        posterImageView.do {
            $0.backgroundColor = .Fill
            $0.layer.cornerRadius = Constant.defaultRadius
        }
        
        titleLabel.do {
            $0.text = Bool.random() ? "세상에서 가장 긴 영화 제목이 만약에 존재한다면 두 줄로 보일 수 있겠지" : "영화 제목"
            $0.numberOfLines = 2
        }
        
        dateLabel.do {
            $0.text = "2024. 04. 25"
        }
        
        likeButton.do {
            $0.setImage(UIImage(systemName: "heart"), for: .normal)
            $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        }
    }
}

// MARK: -MovieSearchViewController-
final class MovieSearchViewController: UIViewController {
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private var movieInfo = SearchMovieResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        callSearchMovieAPI("어벤")
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
        
        return cell
    }
}
// MARK: -
