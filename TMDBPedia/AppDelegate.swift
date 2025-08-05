//
//  AppDelegate.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import Then

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIView.appearance().tintColor = .Tint
        UILabel.appearance().textColor = .Label
        UITextField.appearance().keyboardAppearance = .dark
        
        UINavigationBarAppearance().then {
            $0.backgroundColor = .Background
            $0.titleTextAttributes = [.foregroundColor: UIColor.Label]
        }
        .do {
            UINavigationBar.appearance().standardAppearance = $0
        }
        
        
        UITabBarAppearance().then {
            $0.backgroundColor = .Background
        }
        .do {
            UITabBar.appearance().standardAppearance = $0
        }
        
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
