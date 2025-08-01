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
            $0.top.leading.equalToSuperview(\.safeAreaLayoutGuide).offset(IntConstant.offsetFromVertical)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(IntConstant.textFieldHeight)
        }
        
        editButton.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(IntConstant.offsetFromHorizon)
            $0.height.centerY.equalTo(nicknameLabel)
        }
        
        underlineView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(IntConstant.semiOffsetFromHorizon)
            $0.trailing.equalTo(editButton.snp.leading).multipliedBy(1.1)
            $0.bottom.equalTo(nicknameLabel)
            $0.height.equalTo(1)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(IntConstant.offsetFromRelated)
            $0.horizontalEdges.equalToSuperview().inset(IntConstant.offsetFromHorizon)
            $0.height.equalTo(IntConstant.textFieldHeight)
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
        let handler: (Result<String, NicknameError>) -> Void = { [weak self] result in
            switch result {
            case .success(let nickname):
                self?.nicknameLabel.text = nickname
            case .failure(let error):
                self?.showToast(error.kind.description)
                print(error)
            }
        }
        
        let vc = SettingsNicknameDetailViewController().then {
            $0.bindNicknameHandler(handler: handler)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showToast(_ message: String) {
        let uiView = UIView()
        let label = UILabel()
        
        view.addSubview(uiView)
        
        uiView.do {
            $0.addSubview(label)
            $0.backgroundColor = .Label
            $0.layer.cornerRadius = CGFloatConstant.defaultRadius
        }
        
        label.do {
            $0.text = message
            $0.textColor = .Background
        }
        
        uiView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide).inset(IntConstant.offsetFromVertical)
            $0.height.equalTo(label).multipliedBy(1.5)
            $0.width.equalTo(label).multipliedBy(1.2)
        }
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            uiView.removeFromSuperview()
        }
    }
}
