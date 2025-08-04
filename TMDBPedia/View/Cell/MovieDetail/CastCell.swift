//
//  CastCell.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import Kingfisher
import SnapKit
import Then

// MARK: -CastCell-
final class CastCell: BaseTableViewCell {
    private let actorImageView = UIImageView()
    private let actorNameLabel = UILabel()
    private let actorRoleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        actorImageView.do {
            $0.layer.cornerRadius = $0.bounds.width / 2
        }
    }
}
// MARK: -Open-
extension CastCell {
    public func input(_ item: CreditsItem) {
        if let path = item.profile_path, let url = URL(string: APIURL.todayMoviePosterURL + path) {
            actorImageView.kf.setImage(with: url)
        }
        
        actorNameLabel.text = item.name
        actorRoleLabel.text = item.character
    }
}
// MARK: -Configure-
private extension CastCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        contentView.addSubviews(actorImageView, actorNameLabel, actorRoleLabel)
    }
    
    private func configureLayout() {
        actorImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(0.15).priority(1000)
            $0.height.equalTo(actorImageView.snp.width).priority(999)
            $0.leading.equalToSuperview().priority(998)
            $0.verticalEdges.equalToSuperview().inset(Constant.offsetFromImage).priority(997)
        }
        
        actorNameLabel.snp.makeConstraints {
            $0.leading.equalTo(actorImageView.snp.trailing).offset(Constant.offsetFromHorizon)
            $0.centerY.equalToSuperview()
        }
        
        actorRoleLabel.snp.makeConstraints {
            $0.leading.equalTo(actorNameLabel.snp.trailing).offset(Constant.offsetFromImage)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configureView() {
        actorImageView.do {
            $0.contentMode = .scaleAspectFill
            $0.clipsToBounds = true
            $0.kf.indicatorType = .activity
        }
        
        actorNameLabel.do {
            $0.font = .systemFont(ofSize: Constant.titleSize, weight: .bold)
            $0.textColor = .Label
        }
        
        actorRoleLabel.do {
            $0.font = .systemFont(ofSize: Constant.bodySize)
            $0.textColor = .Placeholder
        }
    }
}
// MARK: -
