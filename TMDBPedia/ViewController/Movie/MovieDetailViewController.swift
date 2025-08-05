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
final class MovieDetailViewController: BaseViewController {
    private var tableView = UITableView()
    private var id: Int?
    private var synopsis: (String, Bool) = ("", false)
    private var searchInfo: SearchMovieItem?
    private var movieInfo: TodayMovieItem?
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
            $0.verticalEdges.equalToSuperview(\.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func configureView() {
        view.backgroundColor = .Background
        tableView.backgroundColor = .Background
    }
}
// MARK: -Open-
extension MovieDetailViewController {
    public func input(_ item: SearchMovieItem) {
        handleInput(item)
    }
    
    private func handleInput(_ item: SearchMovieItem) {
        self.id = item.id
        
        updateNavigation(item.title)
        updateBackdrops(item)
        updateSynopsis(text: item.overview)
        callCreditsAPI(item.id)
    }
    
    public func input(_ item: TodayMovieItem) {
        handleInput(item)
    }
    
    private func handleInput(_ item: TodayMovieItem) {
        self.id = item.id
        
        updateNavigation(item.title)
        updateBackdrops(item)
        updateSynopsis(text: item.overview)
        callCreditsAPI(item.id)
    }
    
    private func updateNavigation(_ text: String) {
        navigationItem.do {
            $0.title = text
            
            var image = UIImage(systemName: "heart")
            if let id {
                let likeList: [Int] = UserDefaultsManager.shared.getArray(.likeList) as? [Int] ?? []
                
                if likeList.contains(id) {
                    image = UIImage(systemName: "heart.fill")
                }
                else {
                    image = UIImage(systemName: "heart")
                }
            }
            
            $0.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(needsLikeAction))
        }
    }
    
    @objc private func needsLikeAction() {
        if let id {
            var likeList: [Int] = UserDefaultsManager.shared.getArray(.likeList) as? [Int] ?? []
            
            if likeList.contains(id) {
                likeList.removeAll(where: { $0 == id })
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            }
            else {
                likeList.append(id)
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            }
            
            UserDefaultsManager.shared.set(.likeList, to: likeList)
        }
    }
    
    private func updateBackdrops(_ item: SearchMovieItem) {
        updateBackdropsImages(item.id)
        updateFooter(item)
    }
    
    private func updateBackdrops(_ item: TodayMovieItem) {
        updateBackdropsImages(item.id)
        updateFooter(item)
    }
    
    private func updateBackdropsImages(_ id: Int) {
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
                    self.tableView.reloadSections([0], with: .automatic)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func updateFooter(_ item: SearchMovieItem) {
        self.searchInfo = item
        tableView.reloadSections([1], with: .automatic)
    }
    
    private func updateFooter(_ item: TodayMovieItem) {
        self.movieInfo = item
        tableView.reloadSections([1], with: .automatic)
    }
    
    private func updateSynopsis(text: String) {
        synopsis.0 = text
        tableView.reloadSections([1], with: .automatic)
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
                    self.tableView.reloadSections([2], with: .automatic)
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
            $0.separatorStyle = .none
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return BaseView(frame: .zero)
        }
        else if section == 1 {
            let uiView = BaseView()
            let headerLabel = UILabel().then {
                $0.text = "Synopsis"
                $0.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
            }
            
            let button = UIButton().then {
                $0.setTitle("More", for: .normal)
                $0.addTarget(self, action: #selector(toggleSynopsis), for: .touchUpInside)
            }
            
            uiView.addSubviews(headerLabel, button)
            
            headerLabel.snp.makeConstraints {
                $0.leading.verticalEdges.equalToSuperview()
            }
            
            button.snp.makeConstraints {
                $0.trailing.verticalEdges.equalToSuperview()
            }
            
            return uiView
        }
        else {
            let headerLabel = UILabel().then {
                $0.text = "Cast"
                $0.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
            }
            
            return headerLabel
        }
    }
    
    @objc private func toggleSynopsis() {
        synopsis.1.toggle()
        tableView.reloadSections([1], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            if let searchInfo {
                let footerLabel = UILabel().then {
                    let font = UIFont.systemFont(ofSize: Constant.placeholderSize)
                    let color = UIColor.Fill
                    let mutableAttributedString = NSMutableAttributedString()
                    let attributedSeparatorString = NSAttributedString(string: "  |  ", attributes: [.font: font])
                    
                    var images = ["calendar", "star.fill"]
                    var texts = [searchInfo.release_date, String(searchInfo.vote_average)]
                    
                    let genres: String = searchInfo.genre_ids
                        .compactMap(MovieGenre.init)
                        .map(\.text)[...min(searchInfo.genre_ids.count, 1)]
                        .joined(separator: ", ")
                    
                    if !genres.isEmpty {
                        images.append("film.fill")
                        texts.append(genres)
                    }
                    
                    for i in 0..<images.count {
                        let textAttachment = NSTextAttachment().then {
                            $0.image = UIImage(systemName: images[i])?
                                .withTintColor(color)
                                .withConfiguration(UIImage.SymbolConfiguration(font: font))
                        }
                        
                        let attributedAttachment = NSAttributedString(attachment: textAttachment)
                        let attributedString = NSAttributedString(string: " \(texts[i])", attributes: [.font: font])
                        
                        mutableAttributedString.do {
                            $0.append(attributedAttachment)
                            $0.append(attributedString)
                        }
                        
                        if i != (images.count - 1) {
                            mutableAttributedString.append(attributedSeparatorString)
                        }
                    }
                    
                    $0.attributedText = mutableAttributedString
                    $0.textColor = color
                    $0.textAlignment = .center
                }
                
                return footerLabel
            }
            else if let movieInfo {
                let footerLabel = UILabel().then {
                    let font = UIFont.systemFont(ofSize: Constant.placeholderSize)
                    let color = UIColor.Fill
                    let mutableAttributedString = NSMutableAttributedString()
                    let attributedSeparatorString = NSAttributedString(string: "  |  ", attributes: [.font: font])
                    
                    var images = ["calendar", "star.fill"]
                    var texts = [movieInfo.release_date, String(movieInfo.vote_average)]
                    
                    let genres: String = movieInfo.genre_ids
                        .compactMap(MovieGenre.init)
                        .map(\.text)[..<min(movieInfo.genre_ids.count, 2)]
                        .joined(separator: ", ")
                    
                    if !genres.isEmpty {
                        images.append("film.fill")
                        texts.append(genres)
                    }
                    
                    for i in 0..<images.count {
                        let textAttachment = NSTextAttachment().then {
                            $0.image = UIImage(systemName: images[i])?
                                .withTintColor(color)
                                .withConfiguration(UIImage.SymbolConfiguration(font: font))
                        }
                        
                        let attributedAttachment = NSAttributedString(attachment: textAttachment)
                        let attributedString = NSAttributedString(string: " \(texts[i])", attributes: [.font: font])
                        
                        mutableAttributedString.do {
                            $0.append(attributedAttachment)
                            $0.append(attributedString)
                        }
                        
                        if i != (images.count - 1) {
                            mutableAttributedString.append(attributedSeparatorString)
                        }
                    }
                    
                    $0.attributedText = mutableAttributedString
                    $0.textColor = color
                    $0.textAlignment = .center
                }
                
                return footerLabel
            }
        }
        
        return BaseView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }
        else {
            return 0
        }
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
            let item = synopsis
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
