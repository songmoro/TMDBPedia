//
//  SplashViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

import UIKit
import SnapKit
import Then

// MARK: -SplashViewController-
final class SplashViewController: BaseViewController {
    private let splashImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}
// MARK: -Configure-
private extension SplashViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        view.addSubviews(splashImageView, titleLabel, descriptionLabel)
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
    }
    
    private func configureView() {
        view.backgroundColor = .Background
        splashImageView.image = UIImage(named: "splash")
        
        titleLabel.do {
            $0.text = "Splash"
            $0.font = UIFont(descriptor: UIFontDescriptor().withSymbolicTraits([.traitBold, .traitItalic])!, size: Constant.largeTitleSize)
        }
        
        descriptionLabel.do {
            $0.text = "송재훈"
            $0.font = .systemFont(ofSize: Constant.titleSize, weight: .light)
            $0.textAlignment = .center
        }
    }
}
// MARK: -
