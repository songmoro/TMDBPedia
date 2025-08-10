//
//  UIViewController+.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/8/25.
//

import UIKit

enum TransitionStyle {
    case present
    case presentNavigation
    case push
}

extension UIViewController {
    final func transition<T: UIViewController>(_ viewController: T, _ style: TransitionStyle) {
        switch style {
        case .present:
            present(viewController, animated: true)
        case .presentNavigation:
            present(UINavigationController(rootViewController: viewController), animated: true)
        case .push:
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
