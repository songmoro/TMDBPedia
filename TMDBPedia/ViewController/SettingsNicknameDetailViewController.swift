//
//  SettingsNicknameDetailViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Then

class SettingsNicknameDetailViewController: UIViewController {
    let nicknameTextField = UITextField()
    let underlineView = UIView()
    let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameTextField.becomeFirstResponder()
    }
    
    func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    func configureSubview() {
        view.addSubviews(nicknameTextField, underlineView, statusLabel)
    }
    
    func configureLayout() {
        nicknameTextField.snp.makeConstraints {
            $0.top.leading.equalToSuperview(\.safeAreaLayoutGuide).offset(30)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(48)
        }
        
        underlineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.bottom.equalTo(nicknameTextField)
            $0.height.equalTo(1)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(nicknameTextField)
        }
    }
    
    func configureView() {
        navigationItem.title = "닉네임 설정"
        
        view.backgroundColor = .Background
        
        underlineView.backgroundColor = .Label
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요."
        
        statusLabel.do {
            $0.text = "2글자 이상 10글자 미만으로 설정해주세요"
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .Tint
        }
    }
}
