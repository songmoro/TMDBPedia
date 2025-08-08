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
        let navigationBarAppearance = UINavigationBarAppearance()
        let tabBarAppearance = UITabBarAppearance()
        
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.Label]
        [navigationBarAppearance, tabBarAppearance].set(\.backgroundColor, .Background)
        
        [
            UICollectionViewCell.appearance(),
            UICollectionView.appearance(),
            UITableView.appearance(),
            UITableViewCell.appearance()
        ].set(\.backgroundColor, .Background)
        
        UIView.appearance().tintColor = .Tint
        UILabel.appearance().textColor = .Label
        UITextField.appearance().keyboardAppearance = .dark
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
