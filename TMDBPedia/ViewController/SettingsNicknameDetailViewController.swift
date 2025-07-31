//
//  SettingsNicknameDetailViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit

class SettingsNicknameDetailViewController: UIViewController {
    let nicknameTextField = UITextField()
    let underlineView = UIView()
    let statusLabel = UILabel()
    
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
        view.addSubviews(nicknameTextField, underlineView, statusLabel)
    }
    
    func configureLayout() {
        nicknameTextField.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide).inset(16)
            $0.top.equalToSuperview(\.safeAreaLayoutGuide).offset(30)
        }
        
        underlineView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(nicknameTextField)
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
        
        statusLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
    }
}
