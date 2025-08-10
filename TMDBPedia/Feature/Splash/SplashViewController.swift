//
//  SplashViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

import UIKit
import SnapKit

// MARK: -SplashViewController-
final class SplashViewController: BaseViewController {
    private let splashImageView = UIImageView(image: UIImage(named: "splash"))
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Splash"
        label.font = UIFont(descriptor: UIFontDescriptor().withSymbolicTraits([.traitBold, .traitItalic])!, size: Constant.largeTitleSize)
        
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "송재훈"
        label.font = .systemFont(ofSize: Constant.titleSize, weight: .light)
        label.textAlignment = .center
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        [splashImageView, titleLabel, descriptionLabel].forEach(view.addSubview)
        
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
}
// MARK: -
