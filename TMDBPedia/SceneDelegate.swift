//
//  SceneDelegate.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .dark
        
        let navigationController = UINavigationController()
        
        if UserDefaults.standard.string(forKey: "nickname") == nil {
            navigationController.setViewControllers([OnboardingViewController()], animated: true)
        }
        else {
            let tabBarController = UITabBarController()
            tabBarController.setViewControllers([MovieViewController()], animated: true)
            
            navigationController.setViewControllers([tabBarController], animated: true)
        }
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
