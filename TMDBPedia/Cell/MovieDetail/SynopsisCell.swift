//
//  SynopsisCell.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import SnapKit
import Then

// MARK: -SynopsisCell-
final class SynopsisCell: UITableViewCell {
    private let synopsisLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: -Open-
extension SynopsisCell {
    public func input(item: (String, Bool)) {
        synopsisLabel.text = item.0
        synopsisLabel.numberOfLines = item.1 ? 0 : 3
    }
}
// MARK: -Configure-
private extension SynopsisCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        contentView.addSubview(synopsisLabel)
    }
    
    private func configureLayout() {
        synopsisLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Constant.offsetFromHorizon)
            $0.trailing.bottom.lessThanOrEqualToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
    
    private func configureView() {
        synopsisLabel.do {
            $0.numberOfLines = 3
        }
    }
}
// MARK: -
