//
//  ProfileView.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/5/25.
//

import UIKit
import SnapKit
import Then

// MARK: -ProfileViewError-
enum ProfileViewErrorReason: Error {
    case failedLoadNickname
}
// MARK: -

// MARK: -ProfileView-
final class ProfileView: BaseView {
    private let nicknameLabel = UILabel()
    private let registerDateLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let storageButton = UIButton()
    private let dateFormatter = DateFormatter()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}
// MARK: -Open-
extension ProfileView {
    public func inputNickname(_ nickname: Nickname) {
        nicknameLabel.text = nickname.text
        registerDateLabel.text = dateFormatter.string(from: nickname.date)
    }
    
    public func inputLikeList(_ likeListCount: Int) {
        storageButton.configuration?.title = "\(likeListCount)개의 무비박스 보관중"
    }
}
// MARK: -Configure-
private extension ProfileView {
    private func configure() {
        configureDateFormatter()
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureDateFormatter() {
        dateFormatter.dateFormat = "yy.MM.dd 가입"
    }
    
    private func configureSubview() {
        [nicknameLabel, registerDateLabel, chevronImageView, storageButton].forEach(addSubview)
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
        isUserInteractionEnabled = true
        backgroundColor = .GroupedBackground
        layer.cornerRadius = Constant.defaultRadius
        
        nicknameLabel.do {
            $0.textColor = .Label
            $0.font = .systemFont(ofSize: Constant.headerSize, weight: .semibold)
        }
        
        chevronImageView.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .Fill
        }
        
        registerDateLabel.do {
            $0.textColor = .Fill
            $0.font = .systemFont(ofSize: Constant.bodySize, weight: .light)
        }
        
        storageButton.do {
            var configuration = UIButton.Configuration.bordered()
            configuration.baseBackgroundColor = .Tint.withAlphaComponent(0.3)
            configuration.baseForegroundColor = .Label
            
            $0.configuration = configuration
            $0.isUserInteractionEnabled = false
        }
    }
}
// MARK: -
