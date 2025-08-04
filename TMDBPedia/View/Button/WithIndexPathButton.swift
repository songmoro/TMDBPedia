//
//  WithIndexPathButton.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/4/25.
//

import UIKit

// MARK: -WithIndexPathButton-
class WithIndexPathButton: BaseButton {
    var indexPath = IndexPath()
    
    init(indexPath: IndexPath = IndexPath()) {
        super.init(frame: .zero)
        self.indexPath = indexPath
    }
    
    func update(_ indexPath: IndexPath) {
        self.indexPath = indexPath
    }
}
// MARK: -
