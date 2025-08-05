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
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let emptyLabel = UILabel()
    
    private var movieInfo = SearchMovieResponse()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}
// MARK: -Open-
extension MovieSearchViewController {
    public func input(keyword: String) {
        searchBar.text = keyword
        _ = textFieldShouldReturn(searchBar.searchTextField)
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
            $0.searchTextField.textColor = .Label
        }
        
        emptyLabel.do {
            $0.text = "원하는 검색결과를 찾지 못했습니다"
            $0.isHidden = true
        }
        
        tableView.do {
            $0.backgroundColor = .Background
        }
    }
    
    private func configureNavigation() {
        navigationItem.do {
            $0.backButtonTitle = ""
            $0.title = "영화 검색"
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
    
    private func achiveKeyword(_ text: String) {
        let keywords = [text] + (UserDefaultsManager.shared.getArray(.keywords) ?? [String]())
        UserDefaultsManager.shared.set(.keywords, to: keywords)
    }
}
// MARK: -Networking-
private extension MovieSearchViewController {
    private func callSearchMovieAPI(_ text: String, handler: @escaping (SearchMovieResponse) -> Void) {
        Task {
            do {
                let response = try await NetworkManager.shared.call(by: MovieAPI.search(text: text), of: SearchMovieResponse.self)
                handleSuccess(response)
            }
            catch let error {
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
        cell.likeButton.do {
            $0.update(indexPath)
            $0.addTarget(self, action: #selector(needsLikeAction), for: .touchUpInside)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MovieDetailViewController()
        let item = movieInfo.results[indexPath.row]
        vc.input(item)
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func needsLikeAction(_ sender: WithIndexPathButton) {
        let indexPath = sender.indexPath
        let item = movieInfo.results[indexPath.item]
        
        var likeList: [Int] = UserDefaultsManager.shared.getArray(.likeList) as? [Int] ?? []
        
        if likeList.contains(item.id) {
            likeList.removeAll(where: { $0 == item.id })
        }
        else {
            likeList.append(item.id)
        }
        
        UserDefaultsManager.shared.set(.likeList, to: likeList)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
// MARK: -
