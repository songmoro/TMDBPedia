//
//  OnboardingViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit

class OnboardingViewController: UIViewController {
    let splashImageView = UIImageView()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    let startButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
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
            $0.centerY.equalToSuperview().multipliedBy(1.2)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
        }
        
        startButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    func configureView() {
        view.backgroundColor = .systemBackground
        
        splashImageView.image = UIImage(named: "splash")
        
        titleLabel.text = "Onboarding"
        
        descriptionLabel.text = "당신만의 영화 세상, TMDBPedia를 시작해보세요."
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.configuration = .roundBordered()
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    @objc func startButtonClicked() {
        navigationController?.pushViewController(SettingsNicknameViewController(), animated: true)
    }
}
