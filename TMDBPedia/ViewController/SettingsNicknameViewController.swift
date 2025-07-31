//
//  SettingsNicknameViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Then

final class SettingsNicknameViewController: UIViewController {
    private let nicknameLabel = UILabel()
    private let editButton = UIButton()
    private let underlineView = UIView()
    private let doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: Configure
private extension SettingsNicknameViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        view.addSubviews(nicknameLabel, editButton, underlineView, doneButton)
    }
    
    private func configureLayout() {
        nicknameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview(\.safeAreaLayoutGuide).offset(30)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(48)
        }
        
        editButton.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.centerY.equalTo(nicknameLabel)
        }
        
        underlineView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalTo(editButton.snp.leading).multipliedBy(1.1)
            $0.bottom.equalTo(nicknameLabel)
            $0.height.equalTo(1)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.height.equalTo(48)
        }
    }
    
    private func configureView() {
        navigationItem.do {
            $0.title = "닉네임 설정"
            $0.backButtonTitle = ""
        }
        
        view.backgroundColor = .Background
        
        editButton.do {
            var configuration = UIButton.Configuration.roundBordered()
            configuration.title = "편집"
            configuration.baseForegroundColor = .Label
            configuration.background.strokeColor = .Label
            $0.configuration = configuration
            
            $0.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        }
        
        underlineView.backgroundColor = .Label
        
        doneButton.do {
            var configuration = UIButton.Configuration.roundBordered()
            configuration.title = "완료"
            $0.configuration = configuration
        }
    }
    
    @objc private func editButtonClicked() {
        let vc = SettingsNicknameDetailViewController().then {
            $0.bindNicknameHandler { [weak self] result in
                switch result {
                case .success(let nickname):
                    self?.nicknameLabel.text = nickname
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
