//
//  MovieSearchViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

import UIKit
import Alamofire
import Kingfisher
import SnapKit
import Then

enum MovieGenre: Int {
    case adventure     = 12 // 모험
    case fantasy       = 14 // 판타지
    case animation     = 16 // 애니메이션
    case drama         = 18 // 드라마
    case horror        = 27 // 공포
    case action        = 28 // 액션
    case comedy        = 35 // 코미디
    case historical    = 36 // 역사
    case western       = 37 // 서부
    case thriller      = 53 // 스릴러
    case crime         = 80 // 범죄
    case documentary   = 99 // 다큐멘터리
    case sf            = 878 // SF
    case mystery       = 9648 // 미스터리
    case musical       = 10402 // 음악
    case romance       = 10749 // 로맨스
    case family        = 10751 // 가족
    case war           = 10752 // 전쟁
    case tv            = 10770 // TV 영화
    
    var text: String {
        switch self {
        case .adventure: "모험"
        case .fantasy: "판타지"
        case .animation: "애니메이션"
        case .drama: "드라마"
        case .horror: "공포"
        case .action: "액션"
        case .comedy: "코미디"
        case .historical: "역사"
        case .western: "서부"
        case .thriller: "스릴러"
        case .crime: "범죄"
        case .documentary: "다큐멘터리"
        case .sf: "SF"
        case .mystery: "미스터리"
        case .musical: "음악"
        case .romance: "로맨스"
        case .family: "가족"
        case .war: "전쟁"
        case .tv: "TV 영화"
        }
    }
}

final class SearchMovieCell: UITableViewCell, IsIdentifiable {
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let genreStackView = UIStackView()
    let likeButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func input(_ item: SearchMovieItem) {
        handleInput(item)
    }
    
    private func handleInput(_ item: SearchMovieItem) {
        if let url = URL(string: APIURL.todayMoviePosterURL + item.poster_path) {
            posterImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = item.title
        dateLabel.text = item.release_date
        
        for genreId in item.genre_ids {
            let label = UILabel().then {
                if let genre = MovieGenre(rawValue: genreId) {
                    $0.text = genre.text
                }
                $0.textColor = .Label
            }
            
            genreStackView.addArrangedSubview(label)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        genreStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        contentView.addSubviews(posterImageView, titleLabel, dateLabel, genreStackView, likeButton)
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
        
        genreStackView.snp.makeConstraints {
            $0.leading.equalTo(posterImageView.snp.trailing).offset(Constant.offsetFromHorizon)
            $0.bottom.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.trailing.lessThanOrEqualTo(likeButton.snp.leading).inset(Constant.offsetFromHorizon)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
    
    private func configureView() {
        posterImageView.do {
            $0.kf.indicatorType = .activity
            $0.backgroundColor = .Fill
            $0.layer.cornerRadius = Constant.defaultRadius
        }
        
        titleLabel.do {
            $0.numberOfLines = 2
        }
        
        genreStackView.do {
            $0.axis = .horizontal
            $0.spacing = CGFloat(Constant.offsetFromTop)
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
        
        let item = movieInfo.results[indexPath.row]
        cell.input(item)
        
        return cell
    }
}
// MARK: -
