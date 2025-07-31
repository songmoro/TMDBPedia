//
//  UIButton+Configuration+.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit

extension UIButton.Configuration {
    static func roundBordered() -> Self {
        var configuration = self.borderless()
        configuration.cornerStyle = .capsule
        configuration.background.strokeWidth = 1
        configuration.background.strokeColor = .tintColor
        
        return configuration
    }
}
