//
//  EmptyHistoryCell.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

import UIKit
import SnapKit

final class EmptyHistoryCell: BaseTableViewCell {
    let emptyLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(emptyLabel)
        
        emptyLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        emptyLabel.text = "최근 검색어 내역이 없습니다."
        emptyLabel.textColor = .Placeholder
        emptyLabel.font = .systemFont(ofSize: Constant.bodySize)
    }
}
