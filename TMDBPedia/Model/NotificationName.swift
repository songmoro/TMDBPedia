//
//  NotificationName.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/4/25.
//

import Foundation

enum NotificationName: String {
    case removeKeyword
    case likeAction
    case pushMovieSearchViewController
    
    var name: Notification.Name {
        return Notification.Name(rawValue: self.rawValue)
    }
}

extension Notification.Name {
    static func by(_ name: NotificationName) -> Self {
        return name.name
    }
}
