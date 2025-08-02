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
final class TodayMovieCell: UITableViewCell, IsIdentifiable {
    private var movieInfoItems = [TodayMovieItem]()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func input(_ items: [TodayMovieItem]) {
        handleInput(items)
    }
    
    private func handleInput(_ items: [TodayMovieItem]) {
        movieInfoItems = items
        collectionView.reloadData()
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
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
    
    private func configureView() {
        
    }
}

extension TodayMovieCell: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.do {
            let layout = UICollectionViewFlowLayout().then {
                let bounds = UIScreen.main.bounds
                $0.itemSize = CGSize(width: bounds.width * 0.6, height: bounds.height * 0.4)
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
        
        return cell
    }
}
// MARK: -

// MARK: -ContentCell-
final class TodayMovieContentCell: UICollectionViewCell, IsIdentifiable {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let likeButton = UIButton()
    private let plotLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func input(_ item: TodayMovieItem) {
        handleInput(item)
    }
    
    private func handleInput(_ item: TodayMovieItem) {
        if let url = URL(string: APIURL.todayMoviePosterURL + item.poster_path) {
            posterImageView.kf.setImage(with: url)
        }
        titleLabel.text = item.title
        plotLabel.text = item.overview
    }
    
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
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalToSuperview().multipliedBy(0.6)
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
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    private func configureView() {
        posterImageView.do {
            $0.kf.indicatorType = .activity
        }
        
        likeButton.do {
            $0.setImage(UIImage(systemName: "heart"), for: .normal)
            $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        }
        
        plotLabel.do {
            $0.numberOfLines = 3
        }
    }
}
// MARK: -
