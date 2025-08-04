//
//  SearchMovieCell.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

import UIKit
import Kingfisher
import SnapKit
import Then

final class SearchMovieCell: BaseTableViewCell {
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let genreStackView = UIStackView()
    let likeButton = WithIndexPathButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    public func input(_ item: SearchMovieItem) {
        handleInput(item)
    }
    
    private func handleInput(_ item: SearchMovieItem) {
        if let url = URL(string: APIURL.todayMoviePosterURL + item.poster_path) {
            posterImageView.kf.setImage(with: url)
        }
        
        titleLabel.text = item.title
        dateLabel.text = item.release_date
        
        let isLiked = UserDefaultsManager.shared.getArray(.likeList)?.contains(where: { ($0 is Int) && ($0 as! Int == item.id) }) ?? false
        likeButton.isSelected = isLiked
        
        let genres = item.genre_ids.compactMap(MovieGenre.init)[..<min(2, item.genre_ids.count)]
        
        for genre in genres {
            let button = UIButton().then {
                $0.isUserInteractionEnabled = false
                
                var configuration = UIButton.Configuration.filled()
                configuration.title = genre.text
                configuration.contentInsets = .init(top: 4, leading: 4, bottom: 4, trailing: 4)
                configuration.background.backgroundColor = .systemGray5
                configuration.baseForegroundColor = .Label
                
                $0.configuration = configuration
            }
            
            genreStackView.addArrangedSubview(button)
            
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        genreStackView.subviews.forEach {
            $0.removeFromSuperview()
        }
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        contentView.addSubviews(posterImageView, titleLabel, dateLabel, genreStackView, likeButton)
    }
    
    private func configureLayout() {
        posterImageView.snp.makeConstraints {
            $0.leading.verticalEdges.equalToSuperview().inset(Constant.offsetFromHorizon).priority(1000)
            $0.width.equalToSuperview().multipliedBy(0.25).priority(999)
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.25)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(Constant.offsetFromHorizon)
        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.offsetFromTop)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(Constant.offsetFromHorizon)
        }
        
        genreStackView.snp.makeConstraints {
            $0.leading.equalTo(posterImageView.snp.trailing).offset(Constant.offsetFromHorizon)
            $0.bottom.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.trailing.lessThanOrEqualTo(likeButton.snp.leading).inset(Constant.offsetFromHorizon)
        }
        
        likeButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
    
    private func configureView() {
        posterImageView.do {
            $0.kf.indicatorType = .activity
            $0.backgroundColor = .Fill
            $0.layer.cornerRadius = Constant.defaultRadius
            $0.clipsToBounds = true
        }
        
        titleLabel.do {
            $0.numberOfLines = 2
        }
        
        genreStackView.do {
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            $0.spacing = CGFloat(Constant.offsetFromTop)
        }
        
        likeButton.do {
            $0.setImage(UIImage(systemName: "heart"), for: .normal)
            $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        }
    }
}
