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
        let movieViewController2 = UINavigationController(rootViewController: MovieViewController())
        
        setViewControllers([movieViewController, movieViewController2], animated: true)
        
        if let items = tabBar.items {
            items[0].selectedImage = UIImage(systemName: "star.fill")
            items[0].image = UIImage(systemName: "star")
            items[0].title = "Item1"
            
            items[1].selectedImage = UIImage(systemName: "moon.fill")
            items[1].image = UIImage(systemName: "moon")
            items[1].title = "Item2"
        }
        
        tabBar.isHidden = false
    }
}
