//
//  OnboardingViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Then

final class OnboardingViewController: UIViewController {
    private let splashImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: Configure
private extension OnboardingViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        view.addSubviews(splashImageView, titleLabel, descriptionLabel, startButton)
    }
    
    private func configureLayout() {
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
            $0.top.equalTo(titleLabel.snp.bottom).offset(Constant.offsetFromHorizon)
        }
        
        startButton.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(Constant.offsetFromRelated)
            $0.horizontalEdges.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide)
            $0.height.equalTo(Constant.textFieldHeight)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .Background
        
        navigationItem.backButtonTitle = ""
        
        splashImageView.image = UIImage(named: "splash")
        
        titleLabel.do {
            $0.text = "Onboarding"
            $0.font = UIFont(descriptor: UIFontDescriptor().withSymbolicTraits([.traitBold, .traitItalic])!, size: Constant.largeTitleSize)
        }
        
        descriptionLabel.do {
            $0.text = "당신만의 영화 세상,\nTMDBPedia를 시작해보세요."
            $0.font = .systemFont(ofSize: Constant.titleSize, weight: .light)
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
    
    @objc private func startButtonClicked() {
        let settingsNicknameViewController = SettingsNicknameViewController().then {
            $0.input(.push)
        }
        
        navigationController?.pushViewController(settingsNicknameViewController, animated: true)
    }
}
