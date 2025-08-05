//
//  BaseView.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/5/25.
//

import UIKit

class BaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .Background
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
