//
//  SettingsNicknameViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Then

class SettingsNicknameViewController: UIViewController {
    let nicknameLabel = UILabel()
    let editButton = UIButton()
    let underlineView = UIView()
    let doneButton = UIButton()
    
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
        view.addSubviews(nicknameLabel, editButton, underlineView, doneButton)
    }
    
    func configureLayout() {
        nicknameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview(\.safeAreaLayoutGuide).offset(30)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(48)
        }
        
        editButton.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing)
            $0.trailing.equalToSuperview()
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
    
    func configureView() {
        navigationItem.do {
            $0.title = "닉네임 설정"
            $0.backButtonTitle = ""
        }
        
        view.backgroundColor = .Background
        
        nicknameLabel.text = "고래밥 99개"
        
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
    
    @objc func editButtonClicked() {
        navigationController?.pushViewController(SettingsNicknameDetailViewController(), animated: true)
    }
}
