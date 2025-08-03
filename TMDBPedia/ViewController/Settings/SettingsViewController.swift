//
//  SettingsViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import SnapKit
import Then

// MARK: -SettingsViewController-
final class SettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}
// MARK: -Configure-
extension SettingsViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureNavigation()
    }
    
    private func configureSubview() {
        
    }
    
    private func configureLayout() {
        
    }
    
    private func configureView() {
        view.backgroundColor = .Background
    }
    
    private func configureNavigation() {
        navigationItem.title = "설정"
    }
}
// MARK: -
