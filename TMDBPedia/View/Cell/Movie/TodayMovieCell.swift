//
//  TodayMovieCell.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

import UIKit
import SnapKit
import Kingfisher
import Then

// MARK: -MovieCell-
final class TodayMovieCell: BaseTableViewCell {
    private var movieInfoItems = [TodayMovieItem]()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
}
// MARK: -Open-
extension TodayMovieCell {
    public func input(_ items: [TodayMovieItem]) {
        movieInfoItems = items
        collectionView.reloadData()
    }
    
    public func needsReload() {
        collectionView.reloadData()
    }
}
// MARK: -Configure-
private extension TodayMovieCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureCollectionView()
    }
    
    private func configureSubview() {
        contentView.addSubview(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.size.equalToSuperview()
        }
    }
}
// MARK: -CollectionView-
extension TodayMovieCell: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.do {
            let layout = UICollectionViewFlowLayout().then {
                let bounds = UIScreen.main.bounds
                $0.itemSize = CGSize(width: bounds.width * 0.6, height: bounds.height * 0.6)
                $0.minimumLineSpacing = CGFloat(Constant.offsetFromHorizon)
                $0.minimumInteritemSpacing = 0
                $0.scrollDirection = .horizontal
            }
            
            $0.delegate = self
            $0.dataSource = self
            $0.register(TodayMovieContentCell.self)
            $0.collectionViewLayout = layout
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieInfoItems.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(TodayMovieContentCell.self, for: indexPath)
        
        let item = movieInfoItems[indexPath.item]
        cell.input(item)
        cell.likeButton.do {
            $0.update(indexPath)
            $0.addTarget(self, action: #selector(postIndexPathForLikeAction), for: .touchUpInside)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        postIndexPathForPushDetailViewController(indexPath)
    }
    
    @objc private func postIndexPathForLikeAction(_ sender: WithIndexPathButton) {
        NotificationCenter.default.post(name: .forName(.likeAction), object: nil, userInfo: ["indexPath": sender.indexPath])
    }
    
    private func postIndexPathForPushDetailViewController(_ sender: IndexPath) {
        NotificationCenter.default.post(name: .forName(.pushMovieDetailViewController), object: nil, userInfo: ["indexPath": sender])
    }
}
// MARK: -

// MARK: -ContentCell-
final class TodayMovieContentCell: BaseCollectionViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    let likeButton = WithIndexPathButton()
    private let plotLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}
// MARK: -Open-
extension TodayMovieContentCell {
    public func input(_ item: TodayMovieItem) {
        handleInput(item)
    }
    
    private func handleInput(_ item: TodayMovieItem) {
        if let url = URL(string: APIURL.todayMoviePosterURL + item.poster_path) {
            posterImageView.kf.setImage(with: url)
        }
        titleLabel.text = item.title
        let isLiked = UserDefaultsManager.shared.getArray(.likeList)?.contains(where: { ($0 is Int) && ($0 as! Int == item.id) }) ?? false
        likeButton.isSelected = isLiked
        plotLabel.text = item.overview
    }
}
// MARK: -Configure-
private extension TodayMovieContentCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        contentView.addSubviews(posterImageView, titleLabel, likeButton, plotLabel)
    }
    
    private func configureLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.width.centerX.equalToSuperview()
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.4)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom)
            $0.leading.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(posterImageView.snp.bottom)
            $0.trailing.equalToSuperview()
        }
        
        plotLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.offsetFromTop)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func configureView() {
        posterImageView.do {
            $0.kf.indicatorType = .activity
        }
        
        titleLabel.do {
            $0.font = .systemFont(ofSize: Constant.titleSize, weight: .bold)
        }
        
        likeButton.do {
            $0.setImage(UIImage(systemName: "heart"), for: .normal)
            $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        }
        
        plotLabel.do {
            $0.font = .systemFont(ofSize: Constant.bodySize, weight: .light)
            $0.numberOfLines = 3
        }
    }
}
// MARK: -
