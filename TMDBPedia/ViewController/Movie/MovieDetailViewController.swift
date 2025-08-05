//
//  MovieDetailViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import SnapKit
import Then

// MARK: -MovieDetailViewController-
final class MovieDetailViewController: BaseViewController {
    private var tableView = UITableView()
    private var id: Int?
    private var synopsis: (String, Bool) = ("", false)
    private var movieItem: MovieItem?
    private var movieInfo: MovieItem?
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
    public func input(_ item: MovieItem) {
        handleInput(item)
    }
    
    private func handleInput(_ item: MovieItem) {
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
    
    private func updateBackdrops(_ item: MovieItem) {
        updateBackdropsImages(item.id)
        updateFooter(item)
    }
    
    private func updateBackdropsImages(_ id: Int) {
        Task {
            do {
                let response = try await NetworkManager.shared.call(by: MovieAPI.images(id: id), of: ImagesResponse.self)
                self.imagesInfo = response
                self.tableView.reloadSections([0], with: .automatic)
            }
            catch let error {
                print(error)
            }
        }
    }
    
    private func updateFooter(_ item: MovieItem) {
        self.movieItem = item
        tableView.reloadSections([1], with: .automatic)
    }
    
    private func updateSynopsis(text: String) {
        synopsis.0 = text
        tableView.reloadSections([1], with: .automatic)
    }
    
    private func callCreditsAPI(_ id: Int) {
        Task {
            do {
                let response = try await NetworkManager.shared.call(by: MovieAPI.credit(id: id), of: CreditsResponse.self)
                self.creditsInfo = response
                self.tableView.reloadSections([2], with: .automatic)
            }
            catch let error {
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
        if section == 2 {
            return creditsInfo.cast.count
        }
        else {
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let uiView = BaseView()
        
        if section == 0 {
            return uiView
        }
        else if section == 1 {
            let headerLabel = UILabel().then {
                $0.text = "Synopsis"
                $0.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
            }
            
            let button = UIButton().then {
                var configuration = UIButton.Configuration.plain()
                var attributedText = AttributedString("More")
                attributedText.foregroundColor = UIColor.Tint
                attributedText.font = .systemFont(ofSize: Constant.titleSize, weight: .bold)
                
                configuration.baseForegroundColor = .Tint
                configuration.attributedTitle = attributedText
                
                $0.configuration = configuration
                $0.addTarget(self, action: #selector(toggleSynopsis), for: .touchUpInside)
            }
            
            uiView.addSubviews(headerLabel, button)
            
            headerLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Constant.offsetFromHorizon)
                $0.centerY.equalToSuperview()
            }
            
            button.snp.makeConstraints {
                $0.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
                $0.centerY.equalToSuperview()
            }
            
            return uiView
        }
        else {
            let headerLabel = UILabel().then {
                $0.text = "Cast"
                $0.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
            }
            
            uiView.addSubview(headerLabel)
            
            headerLabel.snp.makeConstraints {
                $0.leading.equalToSuperview().offset(Constant.offsetFromHorizon)
                $0.centerY.equalToSuperview()
            }
            
            return uiView
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
            if let movieItem {
                let footerLabel = UILabel().then {
                    let font = UIFont.systemFont(ofSize: Constant.placeholderSize)
                    let color = UIColor.Fill
                    let mutableAttributedString = NSMutableAttributedString()
                    let attributedSeparatorString = NSAttributedString(string: "  |  ", attributes: [.font: font])
                    
                    var images = ["calendar", "star.fill"]
                    var texts = [movieItem.release_date, String(movieItem.vote_average)]
                    
                    let genres: String = movieItem.genre_ids
                        .compactMap(MovieGenre.init)
                        .map(\.text)[..<min(movieItem.genre_ids.count, 2)]
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
