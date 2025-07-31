//
//  OnboardingViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Then

class OnboardingViewController: UIViewController {
    let splashImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: Configure
extension OnboardingViewController {
    func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    func configureSubview() {
        view.addSubviews(splashImageView, titleLabel, descriptionLabel, startButton)
    }
    
    func configureLayout() {
        splashImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(1.3)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        startButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide)
            $0.height.equalTo(48)
        }
    }
    
    func configureView() {
        view.backgroundColor = .Background
        
        navigationItem.backButtonTitle = ""
        
        splashImageView.image = UIImage(named: "splash")
        
        titleLabel.do {
            $0.text = "Onboarding"
            $0.font = UIFont(descriptor: UIFontDescriptor().withSymbolicTraits([.traitBold, .traitItalic])!, size: 34)
        }
        
        descriptionLabel.do {
            $0.text = "당신만의 영화 세상,\nTMDBPedia를 시작해보세요."
            $0.font = .systemFont(ofSize: 17, weight: .light)
            $0.textAlignment = .center
            $0.numberOfLines = 2
        }
        
        startButton.do {
            var configuration = UIButton.Configuration.roundBordered()
            configuration.title = "시작하기"
            $0.configuration = configuration
            
            $0.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        }
    }
    
    @objc func startButtonClicked() {
        navigationController?.pushViewController(SettingsNicknameViewController(), animated: true)
    }
}
