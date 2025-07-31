//
//  SettingsNicknameViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit

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
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.top.equalToSuperview(\.safeAreaLayoutGuide).offset(30)
        }
        
        editButton.snp.makeConstraints {
            $0.height.centerY.equalTo(nicknameLabel)
            $0.trailing.equalTo(nicknameLabel.snp.trailing)
        }
        
        underlineView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(nicknameLabel)
            $0.height.equalTo(1)
        }
        
        doneButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(12)
        }
    }
    
    func configureView() {
        navigationItem.title = "닉네임 설정"
        navigationItem.backButtonTitle = ""
        
        view.backgroundColor = .Background
        
        nicknameLabel.text = "고래밥 99개"
        
        editButton.setTitle("편집", for: .normal)
        editButton.configuration = .roundBordered()
        editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        
        underlineView.backgroundColor = .Label
        
        doneButton.setTitle("완료", for: .normal)
        doneButton.configuration = .roundBordered()
    }
    
    @objc func editButtonClicked() {
        navigationController?.pushViewController(SettingsNicknameDetailViewController(), animated: true)
    }
}
