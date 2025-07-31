//
//  UIView+.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview)
    }
}
