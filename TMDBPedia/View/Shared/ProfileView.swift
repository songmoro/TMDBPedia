//
//  ProfileView.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/5/25.
//

import UIKit
import SnapKit
import Then

// MARK: -ProfileView-
final class ProfileView: BaseView {
    private let nicknameLabel = UILabel()
    private let registerDateLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let storageButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}
// MARK: -Open-
extension ProfileView {
    public func updateNicknameLabel(_ text: String) {
        nicknameLabel.text = text
    }
    
    public func updateStorageButton(_ count: Int) {
        storageButton.configuration?.title = "\(count)개의 무비박스 보관중"
    }
}
// MARK: -Configure-
private extension ProfileView {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        addSubviews(nicknameLabel, registerDateLabel, chevronImageView, storageButton)
    }
    
    private func configureLayout() {
        nicknameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Constant.offsetFromHorizon)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.verticalEdges.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
        
        registerDateLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(nicknameLabel)
            $0.trailing.equalTo(chevronImageView.snp.leading).inset(-Constant.offsetFromHorizon)
        }
        
        storageButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Constant.offsetFromHorizon)
            $0.horizontalEdges.bottom.equalToSuperview().inset(Constant.semiOffsetFromHorizon)
        }
    }
    
    private func configureView() {
        backgroundColor = .GroupedBackground
        layer.cornerRadius = Constant.defaultRadius
        isUserInteractionEnabled = true
        
        nicknameLabel.do {
            $0.text = Nickname.get()?.text ?? "닉네임 로딩 실패"
            $0.textColor = .Label
            $0.font = .systemFont(ofSize: Constant.headerSize, weight: .semibold)
        }
        
        chevronImageView.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .Fill
        }
        
        registerDateLabel.do {
            let date = Nickname.get()?.date.description
            
            if let date {
                $0.text = "\(date) 가입"
            }
            else {
                $0.text = "가입 시기 로딩 실패"
            }
            
            $0.textColor = .Fill
            $0.font = .systemFont(ofSize: Constant.bodySize, weight: .light)
        }
        
        storageButton.do {
            var configuration = UIButton.Configuration.bordered()
            configuration.baseBackgroundColor = .Tint.withAlphaComponent(0.3)
            configuration.baseForegroundColor = .Label
            configuration.title = "\(UserDefaultsManager.shared.getArray(.likeList)?.count ?? 0)개의 무비박스 보관중"
            
            $0.configuration = configuration
            $0.isUserInteractionEnabled = false
        }
    }
}
// MARK: -
