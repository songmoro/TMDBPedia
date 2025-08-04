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
    let posterImageView = UIImageView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let genreStackView = UIStackView()
    let likeButton = UIButton()
    
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
        
        for genreId in item.genre_ids {
            let label = UILabel().then {
                if let genre = MovieGenre(rawValue: genreId) {
                    $0.text = genre.text
                }
                $0.textColor = .Label
            }
            
            genreStackView.addArrangedSubview(label)
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
            $0.spacing = CGFloat(Constant.offsetFromTop)
        }
        
        likeButton.do {
            $0.setImage(UIImage(systemName: "heart"), for: .normal)
            $0.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        }
    }
}
