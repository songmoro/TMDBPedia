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
final class TodayMovieCell: BaseTableViewCell, IsIdentifiable {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
}
// MARK: -Open-
extension TodayMovieCell {
    public func setCollectionView(sectionAt tag: Int, cell: (UICollectionViewCell & IsIdentifiable).Type, size: CGSize, delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        collectionView.do {
            $0.tag = tag
            $0.delegate = delegate
            $0.dataSource = delegate
            
            let layout = UICollectionViewFlowLayout().then {
                $0.itemSize = CGSize(width: size.width * 0.6, height: size.width * 0.8)
                $0.minimumLineSpacing = CGFloat(Constant.offsetFromHorizon)
                $0.minimumInteritemSpacing = 0
                $0.scrollDirection = .horizontal
            }
            
            $0.collectionViewLayout = layout
            $0.register(cell)
            $0.reloadData()
        }
    }
}
// MARK: -Configure-
private extension TodayMovieCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        contentView.addSubview(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    private func configureView() {
        backgroundColor = .Background
        contentView.backgroundColor = .Background
        
        collectionView.do {
            $0.backgroundColor = .Background
            $0.showsHorizontalScrollIndicator = false
        }
    }
}
// MARK: -

// MARK: -ContentCell-
final class TodayMovieContentCell: BaseCollectionViewCell, IsIdentifiable {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let likeButton = WithIndexPathButton()
    private let plotLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}
// MARK: -Open-
extension TodayMovieContentCell {
    public func input(_ item: MovieItem) {
        if let posterPath = item.poster_path, let url = URL(string: APIURL.imageURL + posterPath) {
            posterImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = item.title
        
        let isLiked = UserDefaultsManager.shared.likeList?.contains(where: { $0 == item.id }) ?? false
        likeButton.isSelected = isLiked
        plotLabel.text = item.overview
    }
    
    public func updateButton(_ indexPath: IndexPath, _ selector: Selector) {
        likeButton.indexPath = indexPath
        likeButton.addTarget(nil, action: selector, for: .touchUpInside)
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
        [posterImageView, titleLabel, likeButton, plotLabel].forEach(contentView.addSubview)
    }
    
    private func configureLayout() {
        posterImageView.snp.makeConstraints {
            $0.top.width.centerX.equalToSuperview()
            $0.height.lessThanOrEqualTo(posterImageView.snp.width).multipliedBy(1.4)
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
        contentView.backgroundColor = .Background
        
        posterImageView.do {
            $0.kf.indicatorType = .activity
            $0.clipsToBounds = true
            $0.layer.cornerRadius = Constant.defaultRadius
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
