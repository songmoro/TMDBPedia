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
    
    final func showToast(_ message: String) {
        let uiView: UIView = {
            let view = UIView()
            view.backgroundColor = .Label
            view.layer.cornerRadius = Constant.defaultRadius
            
            return view
        }()
        let label: UILabel = {
            let label = UILabel()
            label.text = message
            label.textColor = .Background
            
            return label
        }()
        
        view.addSubview(uiView)
        uiView.addSubview(label)
        
        uiView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide).inset(Constant.offsetFromVertical)
            $0.height.equalTo(label).multipliedBy(1.5)
            $0.width.equalTo(label).multipliedBy(1.2)
        }
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            uiView.removeFromSuperview()
        }
    }
}
