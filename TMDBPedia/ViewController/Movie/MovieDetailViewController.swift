//
//  MovieDetailViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import SnapKit
import Then

enum MovieDetailViewControllerItem: CaseIterable {
    static var allCases: [MovieDetailViewControllerItem] = [
        .backdrops, .synopsis, .cast
    ]
    
    case backdrops, synopsis, cast
    
    var dataSource: (UITableViewCell & IsIdentifiable).Type {
        switch self {
        case .backdrops:
            return BackdropsCell.self
        case .synopsis:
            return SynopsisCell.self
        case .cast:
            return CastCell.self
        }
    }
    
    var collectionViewDataSource: (UICollectionViewCell & IsIdentifiable).Type {
        switch self {
        default:
            return BackdropCell.self
        }
    }
}

// MARK: 아이템에는 타입만 보관
// MARK: -> 데이터 등은 딕셔너리로 타입을 통해 접근하도록 구현
// MARK: EX. [CustomCell.Type: Data]()

// MARK: -MovieDetailViewController-
final class MovieDetailViewController: BaseViewController {
    private var movieDetailViewControllerItem = MovieDetailViewControllerItem.allCases
    
    private var tableView = UITableView()
    private var id: Int?
    private var synopsis: (String, Bool) = ("", false)
    private var movieItem: MovieItem?
    private var imagesInfo = ImagesResponse()
    private var creditsInfo = CreditsResponse()
    
    private var backdrops = [BackdropsItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
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
}
// MARK: -Open-
extension MovieDetailViewController {
    public func input(_ item: MovieItem) {
        handleInput(item)
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
        return movieDetailViewControllerItem.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = HeaderView()
        
        if section == 0 {
            return headerView
        }
        else if section == 1 {
            headerView.withAction("Synopsis", "More", #selector(toggleSynopsis))
            return headerView
        }
        else {
            headerView.plain("Cast")
            return headerView
        }
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
        guard section == 0, let movieItem else { return BaseView(frame: .zero) }
        
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
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = movieDetailViewControllerItem[indexPath.section].dataSource
        let cell = tableView.dequeueReusableCell(dataSource, for: indexPath)
        
        if let cell = cell as? SynopsisCell {
            let item = synopsis
            cell.input(item: item)
        }
        else if let cell = cell as? CastCell {
            let item = creditsInfo.cast[indexPath.row]
            cell.input(item)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let dataSource = movieDetailViewControllerItem[indexPath.section].collectionViewDataSource
        
        switch cell {
        case let cell as BackdropsCell:
            cell.setCollectionView(sectionAt: indexPath.section, cell: dataSource, size: cell.bounds.size, pages: imagesInfo.backdrops.count, delegate: self)
        default:
            break
        }
    }
}
// MARK: -CollectionView-
extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        min(imagesInfo.backdrops.count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dataSource = movieDetailViewControllerItem[indexPath.section].collectionViewDataSource
        let cell = collectionView.dequeueReusableCell(dataSource, for: indexPath)
        
        if collectionView.tag == 0, let cell = cell as? BackdropCell {
            let item = imagesInfo.backdrops[indexPath.item]
            cell.input(item.file_path)
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
//        pageControl.currentPage = index
    }
}
// MARK: -Action-
extension MovieDetailViewController {
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
                if UserDefaultsManager.shared.likeList?.contains(id) ?? false {
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
            if UserDefaultsManager.shared.likeList?.contains(id) ?? false {
                UserDefaultsManager.shared.likeList?.removeAll(where: { $0 == id })
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
            }
            else {
                UserDefaultsManager.shared.likeList?.append(id)
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
            }
        }
    }
    
    private func updateBackdrops(_ item: MovieItem) {
        updateBackdropsImages(item.id)
        updateFooter(item)
    }
    
    private func updateFooter(_ item: MovieItem) {
        self.movieItem = item
        tableView.reloadSections([1], with: .automatic)
    }
    
    private func updateSynopsis(text: String) {
        synopsis.0 = text
        tableView.reloadSections([1], with: .automatic)
    }
    
    @objc private func toggleSynopsis() {
        synopsis.1.toggle()
        tableView.reloadSections([1], with: .automatic)
    }
}
// MARK: -
