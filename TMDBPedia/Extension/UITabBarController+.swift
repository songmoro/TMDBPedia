//
//  UITabBarController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/1/25.
//

import UIKit

extension UITabBarController {
    func replaceToOnboarding() {
        tabBar.isHidden = true
        
        let onboardingViewController = UINavigationController(rootViewController: OnboardingViewController())
        setViewControllers([onboardingViewController], animated: true)
    }
    
    func replaceToMovie() {
        tabBar.isHidden = false
        
        let movieViewController = UINavigationController(rootViewController: MovieViewController())
        let upcomingViewController = UIViewController()
        let settingsViewController = UINavigationController(rootViewController: SettingsViewController())
        
        setViewControllers([movieViewController, upcomingViewController, settingsViewController], animated: true)
        
        if let items = tabBar.items {
            items[0].do {
                $0.selectedImage = UIImage(systemName: "popcorn")
                $0.image = UIImage(systemName: "popcorn")
                $0.title = "CINEMA"
            }
            
            items[1].do {
                $0.selectedImage = UIImage(systemName: "film")
                $0.image = UIImage(systemName: "film")
                $0.title = "UPCOMING"
            }
            
            items[2].do {
                $0.selectedImage = UIImage(systemName: "person.circle")
                $0.image = UIImage(systemName: "person.circle")
                $0.title = "PROFILE"
            }
        }
    }
}
