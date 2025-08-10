//
//  OnboardingViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit

final class OnboardingViewController: BaseViewController {
    private let splashImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "splash")
        
        return iv
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Onboarding"
        label.font = UIFont(descriptor: UIFontDescriptor().withSymbolicTraits([.traitBold, .traitItalic])!, size: Constant.largeTitleSize)
        
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "당신만의 영화 세상,\nTMDBPedia를 시작해보세요."
        label.font = .systemFont(ofSize: Constant.titleSize, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 2
        
       return label
    }()
    private let startButton: UIButton = {
        var configuration = UIButton.Configuration.roundBordered()
        configuration.title = "시작하기"
        
        return UIButton(configuration: configuration)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        navigationItem.backButtonTitle = ""
        
        [splashImageView, titleLabel, descriptionLabel, startButton].forEach(view.addSubview)
        
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
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    @objc private func startButtonClicked() {
        transition(NicknameViewController(), .push)
    }
}
