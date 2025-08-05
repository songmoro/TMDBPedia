//
//  MovieViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/1/25.
//

import UIKit
import SnapKit
import Alamofire
import Then

// MARK: -MovieViewController-
final class MovieViewController: UIViewController {
    private let headerView = UIView()
    private let nicknameLabel = UILabel()
    private let registerDateLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let storageButton = UIButton()
    
    private let tableView = UITableView()
    
    private var movieInfo = TodayMovieResponse()
    
    private var keywords: [String] = UserDefaultsManager.shared.getArray(.keywords) as? [String] ?? []
    private var likeList: [Int] = UserDefaultsManager.shared.getArray(.likeList) as? [Int] ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        callTodayMovieAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nicknameLabel.text = Nickname.get()?.text ?? "닉네임 로딩 실패"
        keywords = UserDefaultsManager.shared.getArray(.keywords) as? [String] ?? []
        likeList = UserDefaultsManager.shared.getArray(.likeList) as? [Int] ?? []
        tableView.reloadData()
    }
}
// MARK: -Configure-
private extension MovieViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureNavigation()
        configureTableView()
        configureObserver()
    }
    
    private func configureSubview() {
        headerView.addSubviews(nicknameLabel, registerDateLabel, chevronImageView, storageButton)
        view.addSubviews(headerView, tableView)
    }
    
    private func configureLayout() {
        headerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide).inset(Constant.offsetFromHorizon)
            $0.height.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Constant.offsetFromHorizon)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.verticalEdges.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
        
        registerDateLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(nicknameLabel)
            $0.trailing.equalTo(chevronImageView.snp.leading).inset(-Constant.offsetFromHorizon)
        }
        
        storageButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Constant.offsetFromHorizon)
            $0.horizontalEdges.bottom.equalToSuperview().inset(Constant.semiOffsetFromHorizon)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Constant.offsetFromRelated)
            $0.horizontalEdges.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .Background
        
        headerView.do {
            let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(settingsNickname))
            $0.backgroundColor = .systemGray5
            $0.layer.cornerRadius = Constant.defaultRadius
            $0.isUserInteractionEnabled = true
            $0.addGestureRecognizer(tapGestrue)
        }
        
        nicknameLabel.do {
            $0.text = Nickname.get()?.text ?? "닉네임 로딩 실패"
            $0.textColor = .Label
            $0.font = .systemFont(ofSize: Constant.headerSize, weight: .semibold)
        }
        
        chevronImageView.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .Fill
        }
        
        registerDateLabel.do {
            let date = Nickname.get()?.date.description
            
            if let date {
                $0.text = "\(date) 가입"
            }
            else {
                $0.text = "가입 시기 로딩 실패"
            }
            
            $0.textColor = .Fill
            $0.font = .systemFont(ofSize: Constant.bodySize, weight: .light)
        }
        
        storageButton.do {
            var configuration = UIButton.Configuration.bordered()
            configuration.baseBackgroundColor = .Tint.withAlphaComponent(0.3)
            configuration.baseForegroundColor = .Label
            configuration.title = "\(UserDefaultsManager.shared.getArray(.likeList)?.count ?? 0)개의 무비박스 보관중"
            
            $0.configuration = configuration
            
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func configureNavigation() {
        navigationItem.do {
            $0.title = "TMDBPedia"
            $0.backButtonTitle = ""
            
            let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
            $0.setRightBarButton(rightBarButton, animated: true)
        }
    }
    
    @objc private func searchButtonTapped() {
        pushSearchViewController()
    }
    
    private func pushSearchViewController() {
        let vc = MovieSearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func settingsNickname() {
        let settingsNicknameViewContoller = SettingsNicknameViewController().then {
            $0.input(.present)
            $0.bind(presentDismissHandler: updateNicknameLabel)
        }
        
        let navigationController = UINavigationController(rootViewController: settingsNicknameViewContoller)
        present(navigationController, animated: true)
    }
    
    private func updateNicknameLabel() {
        nicknameLabel.text = Nickname.get()?.text ?? "닉네임 로딩 실패"
    }
}
// MARK: -NotificationCenter-
extension MovieViewController {
    private func configureObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(needsUpdateKeywords), name: .forName(.removeKeyword), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(needsLikeAction), name: .forName(.likeAction), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(needsPushMovieSearchViewController), name: .forName(.pushMovieSearchViewController), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(needsPushMovieDetailViewController), name: .forName(.pushMovieDetailViewController), object: nil)
    }
    
    @objc private func needsUpdateKeywords(_ notification: NSNotification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath, let historyCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? HistoryCell {
            keywords.remove(at: indexPath.item)
            UserDefaultsManager.shared.set(.keywords, to: keywords)
            
            tableView.reloadData()
            historyCell.needsReload()
        }
    }
    
    @objc private func needsLikeAction(_ notification: NSNotification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath, let todayMovieCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? TodayMovieCell {
            let item = movieInfo.results[indexPath.item]
            
            if likeList.contains(item.id) {
                likeList.removeAll(where: { $0 == item.id })
            }
            else {
                likeList.append(item.id)
            }
            
            UserDefaultsManager.shared.set(.likeList, to: likeList)
            storageButton.configuration?.title = "\(likeList.count)개의 무비박스 보관중"
            tableView.reloadData()
            todayMovieCell.needsReload()
        }
    }
    
    @objc private func needsPushMovieSearchViewController(_ notification: NSNotification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            let keyword = keywords[indexPath.item]
            
            let vc = MovieSearchViewController().then {
                $0.input(keyword: keyword)
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func needsPushMovieDetailViewController(_ notification: NSNotification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            let item = movieInfo.results[indexPath.item]
            
            let vc = MovieDetailViewController().then {
                $0.input(item)
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
// MARK: -Network-
private extension MovieViewController {
    private func callTodayMovieAPI() {
        let url = URL(string: APIURL.todayMovieURL)!
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [URLQueryItem(name: "language", value: "ko-KR")]
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
            .responseDecodable(of: TodayMovieResponse.self) {
                switch $0.result {
                case .success(let todayMovieResponse):
                    self.handleSuccess(todayMovieResponse)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func handleSuccess(_ response: TodayMovieResponse) {
        movieInfo = response
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
    }
}
// MARK: -TableView-
extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
            $0.register(EmptyHistoryCell.self)
            $0.register(HistoryCell.self)
            $0.register(TodayMovieCell.self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if indexPath.section == 0 {
            if keywords.isEmpty {
                cell = tableView.dequeueReusableCell(EmptyHistoryCell.self, for: indexPath)
            }
            else {
                cell = tableView.dequeueReusableCell(HistoryCell.self, for: indexPath).then {
                    $0.input(keywords)
                }
            }
        }
        else {
            cell = tableView.dequeueReusableCell(TodayMovieCell.self, for: indexPath).then {
                $0.input(movieInfo.results)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(Constant.textFieldHeight)
        }
        else {
            return UIScreen.main.bounds.height * 0.4
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let uiView: UIView
        
        if section == 0 {
            uiView = UIView()
            
            let headerLabel = UILabel().then {
                $0.text = "최근검색어"
                $0.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
            }
            
            let button = UIButton().then {
                $0.setTitle("전체 삭제", for: .normal)
                $0.addTarget(self, action: #selector(removeAllKeyword), for: .touchUpInside)
            }
            
            uiView.addSubviews(headerLabel, button)
            
            headerLabel.snp.makeConstraints {
                $0.leading.verticalEdges.equalToSuperview()
            }
            
            button.snp.makeConstraints {
                $0.trailing.verticalEdges.equalToSuperview()
            }
        }
        else {
            uiView = UILabel().then {
                $0.text = "오늘의 영화"
                $0.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
            }
        }
        
        return uiView
    }
    
    @objc private func removeAllKeyword() {
        keywords = []
        UserDefaultsManager.shared.remove(.keywords)
        
        tableView.reloadSections([0], with: .automatic)
    }
}
// MARK: -
