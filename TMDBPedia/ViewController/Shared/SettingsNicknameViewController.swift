//
//  SettingsNicknameViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Then

// MARK: -SettingsNicknameViewController-
final class SettingsNicknameViewController: BaseViewController {
    private var nickname = Nickname(text: "")
    private let nicknameLabel = UILabel()
    private let editButton = UIButton()
    private let underlineView = UIView()
    private let doneButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}
// MARK: -Open-
extension SettingsNicknameViewController {
    public func inputNickname(_ currentNickname: Nickname) {
        handleEntryPoint(currentNickname)
    }
}
// MARK: -Configure-
private extension SettingsNicknameViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func handleEntryPoint(_ nickname: Nickname) {
        self.nickname = nickname
        nicknameLabel.text = nickname.text
        doneButton.isHidden = true
        
        navigationItem.do {
            $0.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
            $0.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        }
    }
    
    private func configureSubview() {
        view.addSubviews(nicknameLabel, editButton, underlineView, doneButton)
    }
    
    private func configureLayout() {
        nicknameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview(\.safeAreaLayoutGuide).offset(Constant.offsetFromVertical)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(Constant.textFieldHeight)
        }
        
        editButton.snp.makeConstraints {
            $0.leading.equalTo(nicknameLabel.snp.trailing)
            $0.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.height.centerY.equalTo(nicknameLabel)
        }
        
        underlineView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Constant.semiOffsetFromHorizon)
            $0.trailing.equalTo(editButton.snp.leading).multipliedBy(1.1)
            $0.bottom.equalTo(nicknameLabel)
            $0.height.equalTo(1)
        }
        
        doneButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Constant.offsetFromRelated)
            $0.horizontalEdges.equalToSuperview().inset(Constant.offsetFromHorizon)
            $0.height.equalTo(Constant.textFieldHeight)
        }
    }
    
    private func configureView() {
        navigationItem.do {
            $0.title = "닉네임 설정"
            $0.backButtonTitle = ""
        }
        
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
            $0.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
        }
    }
    
    @objc private func dismissButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func editButtonClicked() {
        pushSettingsNicknameDetailViewController()
    }
    
    @objc private func saveButtonClicked() {
        handleUpdate()
    }
    
    @objc private func doneButtonClicked() {
        handleRegister()
    }
}
// MARK: -Nickname-
private extension SettingsNicknameViewController {
    private func handleRegister() {
        switch nickname.validateNickname {
        case .success(let success):
            saveNickname(success)
            replaceRootViewController()
        case .failure(let failure):
            showToast(failure.kind.description)
        }
    }
    
    private func handleUpdate() {
        switch nickname.validateNickname {
        case .success(let success):
            saveNickname(success)
            dismissButtonClicked()
        case .failure(let failure):
            showToast(failure.kind.description)
        }
    }
    
    private func saveNickname(_ nickname: Nickname) {
        UserDefaultsManager.shared.nickname = nickname
    }
    
    private func replaceRootViewController() {
        tabBarController?.replaceToMovie()
    }
    
    private func showToast(_ message: String) {
        let uiView = UIView()
        let label = UILabel()
        
        view.addSubview(uiView)
        
        uiView.do {
            $0.addSubview(label)
            $0.backgroundColor = .Label
            $0.layer.cornerRadius = Constant.defaultRadius
        }
        
        label.do {
            $0.text = message
            $0.textColor = .Background
        }
        
        uiView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview(\.safeAreaLayoutGuide).inset(Constant.offsetFromVertical)
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
    
    private func pushSettingsNicknameDetailViewController() {
        let vc = SettingsNicknameDetailViewController().then {
            $0.inputNickname(nickname)
            $0.bindNicknameHandler(handler: handleNicknameHandler)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleNicknameHandler(_ nickname: Nickname) {
        self.nickname = nickname
        nicknameLabel.text = nickname.text
    }
}
// MARK: -
