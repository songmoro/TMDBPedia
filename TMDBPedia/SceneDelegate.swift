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
        
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
        
        let tabBarController = UITabBarController()
        
        if UserDefaults.standard.string(forKey: "nickname") == nil {
            let onboardingViewController = UINavigationController(rootViewController: OnboardingViewController())
            
            tabBarController.tabBar.isHidden = true
            tabBarController.setViewControllers([onboardingViewController], animated: true)
        }
        else {
            tabBarController.replaceViewControllerAndVisibleTabbar()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.window?.rootViewController = tabBarController
        }
    }
}
