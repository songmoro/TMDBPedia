//
//  BackdropCell.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import SnapKit
import Kingfisher
import Then

// MARK: -BackdropCell-
final class BackdropCell: BaseCollectionViewCell {
    private let backdropImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}
// MARK: -Open-
extension BackdropCell {
    public func input(_ item: String) {
        if let url = URL(string: APIURL.imageURL + item) {
            backdropImageView.kf.setImage(with: url)
        }
    }
}
// MARK: -Configure-
private extension BackdropCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        contentView.addSubview(backdropImageView)
    }
    
    private func configureLayout() {
        backdropImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configureView() {
        backgroundColor = .Background
        
        backdropImageView.do {
            $0.backgroundColor = .Background
            $0.kf.indicatorType = .activity
        }
    }
}
// MARK: -
