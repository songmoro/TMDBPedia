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
        handleInput(item)
    }
    
    private func handleInput(_ item: String) {
        if let url = URL(string: APIURL.todayMoviePosterURL + item) {
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
        backdropImageView.do {
            let systemColors: [UIColor] = [.systemBlue, .systemRed, .systemPink, .systemOrange, .systemMint, .systemTeal, .systemGreen, .systemCyan, .systemBrown]
            $0.backgroundColor = systemColors.randomElement()!
            $0.kf.indicatorType = .activity
        }
    }
}
// MARK: -
