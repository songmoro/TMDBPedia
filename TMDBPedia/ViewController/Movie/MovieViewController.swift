//
//  MovieViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/1/25.
//

import UIKit
import SnapKit
import Then
import Combine

fileprivate enum MovieViewControllerItem: CaseIterable {
    static var allCases: [MovieViewControllerItem] = [
        .history(keywords: []),
        .todayMovie(movieResponse: MovieResponse())
    ]
    
    case history(keywords: [Keyword])
    case todayMovie(movieResponse: MovieResponse)
    
    var height: CGFloat {
        switch self {
        case .history:
            return CGFloat(Constant.textFieldHeight)
        case .todayMovie:
            return UIScreen.main.bounds.height * 0.4
        }
    }
    
    var dataSource: (UITableViewCell & IsIdentifiable).Type {
        switch self {
        case .history(let keywords):
            return keywords.isEmpty ? EmptyHistoryCell.self : HistoryCell.self
        case .todayMovie:
            return TodayMovieCell.self
        }
    }
}

extension [MovieViewControllerItem] {
    // TODO: 테이블 뷰 셀을 외부로 이동 작업 후 구조 다시 고민
    mutating func inputKeywords(_ keywords: [Keyword]) {
        self[0] = .history(keywords: keywords)
    }
    
    mutating func inputMovieResponse(_ movieResponse: MovieResponse) {
        self[1] = .todayMovie(movieResponse: movieResponse)
    }
    
    var unsafeMovieResponse: MovieResponse {
        if case let .todayMovie(movieResponse) = self[1] {
            return movieResponse
        }
        
        fatalError("응답이 존재하지 않음")
    }
    
    var unsafeKeywords: [Keyword] {
        if case let .history(keywords) = self[0] {
            return keywords
        }
        
        fatalError("키워드가 존재하지 않음")
    }
}

// MARK: -MovieViewController-
final class MovieViewController: BaseViewController {
    private let profileView = ProfileView()
    private let tableView = UITableView()
    private var historyCell: HistoryCell?
    private var todayMovieCell: TodayMovieCell?
    
    private var movieViewControllerItem = MovieViewControllerItem.allCases
    
    private var cancellable = Set<AnyCancellable>()
    private var nickname: Nickname = .init(text: "")
    private var likeList: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configure()
        callTodayMovieAPI()
    }
}
// MARK: -Configure-
private extension MovieViewController {
    private func bind() {
        UserDefaultsManager.shared.$keywords
            .replaceNil(with: [])
            .map {
                return [Keyword]($0).sorted(by: { $0.date > $1.date })
            }
            .sink {
                self.movieViewControllerItem.inputKeywords($0)
                self.tableView.reloadData()
                self.historyCell?.needsReload()
            }
            .store(in: &cancellable)
        
        UserDefaultsManager.shared.$likeList
            .replaceNil(with: [])
            .handleEvents(receiveOutput: {
                self.tableView.reloadData()
                self.todayMovieCell?.needsReload()
                self.profileView.inputLikeList($0.count)
            })
            .assign(to: \.likeList, on: self)
            .store(in: &cancellable)
        
        UserDefaultsManager.shared.$nickname
            .compactMap(\.self)
            .handleEvents(receiveOutput: {
                self.profileView.inputNickname($0)
            })
            .assign(to: \.nickname, on: self)
            .store(in: &cancellable)
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureTableView()
        configureObserver()
    }
    
    private func configureSubview() {
        view.addSubviews(profileView, tableView)
    }
    
    private func configureLayout() {
        profileView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide).inset(Constant.offsetFromHorizon)
            $0.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(Constant.offsetFromRelated)
            $0.horizontalEdges.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        navigationItem.do {
            $0.title = "TMDBPedia"
            $0.backButtonTitle = ""
            
            let rightBarButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
            $0.setRightBarButton(rightBarButton, animated: true)
        }
        
        view.backgroundColor = .Background
        
        profileView.do {
            let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(settingsNickname))
            $0.addGestureRecognizer(tapGestrue)
        }
        
        tableView.do {
            $0.backgroundColor = .Background
        }
    }
    
    @objc private func searchButtonTapped() {
        navigationController?.pushViewController(MovieSearchViewController(), animated: true)
    }
    
    @objc private func settingsNickname() {
        let settingsNicknameViewContoller = SettingsNicknameViewController().then {
            $0.inputNickname(nickname)
        }
        
        let navigationController = UINavigationController(rootViewController: settingsNicknameViewContoller)
        present(navigationController, animated: true)
    }
}
// MARK: -NotificationCenter-
extension MovieViewController {
    private func configureObserver() {
        NotificationCenter.default.do {
            $0.addObserver(self, selector: #selector(needsUpdateKeywords), name: .forName(.removeKeyword), object: nil)
            $0.addObserver(self, selector: #selector(needsLikeAction), name: .forName(.likeAction), object: nil)
            $0.addObserver(self, selector: #selector(needsPushMovieSearchViewController), name: .forName(.pushMovieSearchViewController), object: nil)
            $0.addObserver(self, selector: #selector(needsPushMovieDetailViewController), name: .forName(.pushMovieDetailViewController), object: nil)
        }
    }
    
    @objc private func needsUpdateKeywords(_ notification: NSNotification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            let keywords = movieViewControllerItem.unsafeKeywords
            let keyword = keywords[indexPath.item]
            
            UserDefaultsManager.shared.keywords?.remove(keyword)
        }
    }
    
    @objc private func needsLikeAction(_ notification: NSNotification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            let movieResponse = movieViewControllerItem.unsafeMovieResponse
            let item = movieResponse.results[indexPath.item]
            
            if UserDefaultsManager.shared.likeList?.contains(item.id) ?? false {
                UserDefaultsManager.shared.likeList?.removeAll(where: { $0 == item.id })
            }
            else {
                UserDefaultsManager.shared.likeList?.append(item.id)
            }
            
            profileView.inputLikeList(likeList.count)
        }
    }
    
    @objc private func needsPushMovieSearchViewController(_ notification: NSNotification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            let keywords = movieViewControllerItem.unsafeKeywords
            let oldKeyword = keywords[indexPath.item]
            let newKeyword = Keyword(text: oldKeyword.text)
            
            UserDefaultsManager.shared.keywords?.update(with: newKeyword)
            
            let vc = MovieSearchViewController().then {
                $0.input(keyword: newKeyword)
            }
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func needsPushMovieDetailViewController(_ notification: NSNotification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            let movieResponse = movieViewControllerItem.unsafeMovieResponse
            let item = movieResponse.results[indexPath.item]
            
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
        Task {
            do {
                let response = try await NetworkManager.shared.call(by: MovieAPI.trending, of: MovieResponse.self)
                handleSuccess(response)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    private func handleSuccess(_ response: MovieResponse) {
        let response = response.results.count >= 20 ? MovieResponse(results: Array(response.results[..<20])) : response
        movieViewControllerItem.inputMovieResponse(response)
        
        tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
    }
}
// MARK: -TableView-
extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        tableView.do {
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
            $0.delegate = self
            $0.dataSource = self
            $0.register(EmptyHistoryCell.self)
            $0.register(HistoryCell.self)
            $0.register(TodayMovieCell.self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieViewControllerItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = movieViewControllerItem[indexPath.section].dataSource
        // MARK: BaseTableViewCell에 IsIdentifiable 채택은 하위 뷰의 identifier 또한 BaseTableViewCell로 만듬
        let cell = tableView.dequeueReusableCell(dataSource, for: indexPath)
        
        switch cell {
        case is EmptyHistoryCell:
            historyCell = nil
            
        case let cell as HistoryCell:
            let keywords = movieViewControllerItem.unsafeKeywords
            cell.input(keywords)
            historyCell = cell
            
        case let cell as TodayMovieCell:
            let movieResponse = movieViewControllerItem.unsafeMovieResponse
            cell.input(movieResponse.results)
            todayMovieCell = cell
            
        default: break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        movieViewControllerItem[indexPath.section].height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderView()
            
        switch movieViewControllerItem[section] {
        case .history:
            header.withAction("최근검색어", "전체 삭제", #selector(removeAllKeyword))
        case .todayMovie:
            header.plain("오늘의 영화")
        }
        
        return header
    }
    
    @objc private func removeAllKeyword() {
        UserDefaultsManager.shared.keywords?.removeAll()
    }
}
// MARK: -
