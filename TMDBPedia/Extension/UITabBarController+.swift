//
//  UITabBarController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/1/25.
//

import UIKit

extension UITabBarController {
    func replaceViewControllerAndVisibleTabbar() {
        let movieViewController = UINavigationController(rootViewController: MovieViewController())
        let upcomingViewController = UIViewController()
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        
        setViewControllers([movieViewController, upcomingViewController, settingsViewController], animated: true)
        
        if let items = tabBar.items {
            items[0].selectedImage = UIImage(systemName: "popcorn")
            items[0].image = UIImage(systemName: "popcorn")
            items[0].title = "CINEMA"
            
            items[1].selectedImage = UIImage(systemName: "film")
            items[1].image = UIImage(systemName: "film")
            items[1].title = "UPCOMING"
            
            items[2].selectedImage = UIImage(systemName: "person.circle")
            items[2].image = UIImage(systemName: "person.circle")
            items[2].title = "PROFILE"
        }
        
        tabBar.isHidden = false
    }
}
