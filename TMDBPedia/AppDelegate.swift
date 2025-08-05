//
//  AppDelegate.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIView.appearance().tintColor = .Tint
        UILabel.appearance().textColor = .Label
        
        let navigationStandard = UINavigationBarAppearance()
        navigationStandard.backgroundColor = .Background
        UINavigationBar.appearance().standardAppearance = navigationStandard
        
        let tabBarStandard = UITabBarAppearance()
        tabBarStandard.backgroundColor = .Background
        UITabBar.appearance().standardAppearance = tabBarStandard
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
