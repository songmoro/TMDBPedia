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

// MARK: -MovieViewController-
final class MovieViewController: BaseViewController {
    private let profileView = ProfileView()
    private let tableView = UITableView()
    private var historyCell: HistoryCell?
    private var todayMovieCell: TodayMovieCell?
    
    private var movieInfo = MovieResponse()
    
    private var cancellable = Set<AnyCancellable>()
    private var nickname: Nickname = .init(text: "")
    private var keywords: [Keyword] = []
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
            .handleEvents(receiveOutput: { _ in
                self.tableView.reloadData()
                self.historyCell?.needsReload()
            })
            .map {
                [Keyword]($0).sorted(by: { $0.date > $1.date })
            }
            .assign(to: \.keywords, on: self)
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
            let keyword = keywords[indexPath.item]
            UserDefaultsManager.shared.keywords?.remove(keyword)
        }
    }
    
    @objc private func needsLikeAction(_ notification: NSNotification) {
        if let indexPath = notification.userInfo?["indexPath"] as? IndexPath {
            let item = movieInfo.results[indexPath.item]
            
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
            let oldKeyword = keywords[indexPath.item]
            let newKeyword = Keyword(text: oldKeyword.text)
            
            UserDefaultsManager.shared.keywords?.update(with: newKeyword)
//            UserDefaultsManager.shared.keywords?.update(with: <#T##Keyword#>) [indexPath.item] = keyword
            
            let vc = MovieSearchViewController().then {
                $0.input(keyword: newKeyword)
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
        if response.results.count >= 20 {
            let result = MovieResponse(results: Array(response.results[..<20]))
            movieInfo = result
        }
        else {
            movieInfo = response
        }
        
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
                historyCell = nil
                cell = tableView.dequeueReusableCell(EmptyHistoryCell.self, for: indexPath)
            }
            else {
                cell = tableView.dequeueReusableCell(HistoryCell.self, for: indexPath).then {
                    $0.input(keywords)
                }
                
                historyCell = cell as? HistoryCell
            }
        }
        else {
            cell = tableView.dequeueReusableCell(TodayMovieCell.self, for: indexPath).then {
                $0.input(movieInfo.results)
            }
            
            todayMovieCell = cell as? TodayMovieCell
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
        let uiView = BaseView()
        
        if section == 0 {
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
                $0.leading.equalToSuperview().inset(Constant.offsetFromHorizon)
            }
            
            button.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
            }
        }
        else {
            let label = UILabel().then {
                $0.text = "오늘의 영화"
                $0.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
            }
            
            uiView.addSubview(label)
            
            label.snp.makeConstraints {
                $0.leading.equalToSuperview().inset(Constant.offsetFromHorizon)
            }
        }
        
        return uiView
    }
    
    @objc private func removeAllKeyword() {
        UserDefaultsManager.shared.keywords?.removeAll()
    }
}
// MARK: -
