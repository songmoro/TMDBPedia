//
//  BaseCollecctionViewCell.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/4/25.
//

import UIKit

class BaseCollecctionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
