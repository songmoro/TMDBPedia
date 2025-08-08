//
//  MovieSearchViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

import UIKit
import SnapKit
import Then

// MARK: -MovieSearchViewController-
final class MovieSearchViewController: BaseViewController {
    private var isKeywordAccess = false
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    
    private var movieInfo = MovieResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isKeywordAccess {
            searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}
// MARK: -Open-
extension MovieSearchViewController {
    public func input(keyword: Keyword) {
        isKeywordAccess = true
        searchBar.text = keyword.text
        _ = textFieldShouldReturn(searchBar.searchTextField)
    }
}
// MARK: -Configure-
private extension MovieSearchViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureTableView()
        configureSearchBar()
    }
    
    private func configureSubview() {
        [searchBar, tableView, emptyLabel].forEach(view.addSubview)
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
        navigationItem.do {
            $0.backButtonTitle = ""
            $0.title = "영화 검색"
        }
        
        view.backgroundColor = .Background
        
        searchBar.do {
            $0.searchBarStyle = .minimal
            $0.searchTextField.leftView?.tintColor = .Label
            $0.searchTextField.textColor = .Label
            $0.searchTextField.backgroundColor = .GroupedBackground
        }
        
        emptyLabel.do {
            $0.text = "원하는 검색결과를 찾지 못했습니다"
            $0.textColor = .Label
            $0.isHidden = true
        }
        
        tableView.do {
            $0.backgroundColor = .Background
            $0.keyboardDismissMode = .interactive
        }
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
        
        achiveKeyword(text)
        callSearchMovieAPI(text)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        movieInfo = .init()
        tableView.reloadData()
        
        return true
    }
    
    private func achiveKeyword(_ text: String) {
        let newKeyword = Keyword(text: text)
        UserDefaultsManager.shared.keywords?.insert(newKeyword)
    }
}
// MARK: -Networking-
private extension MovieSearchViewController {
    private func callSearchMovieAPI(_ text: String) {
        Task {
            do {
                let response = try await NetworkManager.shared.call(by: MovieAPI.search(text: text, page: movieInfo.page), of: MovieResponse.self)
                handleSuccess(response)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    private func handleSuccess(_ response: MovieResponse) {
        if movieInfo.results.isEmpty {
            movieInfo = response
        }
        else {
            movieInfo.page = response.page
            movieInfo.results += response.results
        }
        
        if movieInfo.results.isEmpty {
            emptyLabel.isHidden = false
            tableView.isHidden = true
        }
        else {
            emptyLabel.isHidden = true
            tableView.isHidden = false
        }
        
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
        cell.likeButton.do {
            $0.update(indexPath)
            $0.addTarget(self, action: #selector(needsLikeAction), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if movieInfo.hasNextPage(indexPath.row) {
            movieInfo.page += 1
            _ = textFieldShouldReturn(searchBar.searchTextField)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = movieInfo.results[indexPath.row]
        let vc = MovieDetailViewController().then {
            $0.input(item)
        }
        
        transition(vc, .push)
    }
    
    @objc private func needsLikeAction(_ sender: WithIndexPathButton) {
        let indexPath = sender.indexPath
        let item = movieInfo.results[indexPath.item]
        
        if UserDefaultsManager.shared.likeList?.contains(item.id) ?? false {
            UserDefaultsManager.shared.likeList?.removeAll(where: { $0 == item.id })
        }
        else {
            UserDefaultsManager.shared.likeList?.append(item.id)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
// MARK: -
