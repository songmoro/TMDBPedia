//
//  SettingsNicknameViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Then

enum EntryPoint {
    case present
    case push
}

// MARK: -SettingsNicknameViewController-
final class SettingsNicknameViewController: UIViewController {
    private let nicknameLabel = UILabel()
    private let editButton = UIButton()
    private let underlineView = UIView()
    private let doneButton = UIButton()
    private var presentDismissHandler: (() -> Void)?
    
    private var entryPoint: EntryPoint?
}
// MARK: -Open-
extension SettingsNicknameViewController {
    public func input(_ entryPoint: EntryPoint) {
        handleInput(entryPoint)
    }
    
    public func bind(presentDismissHandler: @escaping () -> Void) {
        self.presentDismissHandler = presentDismissHandler
    }
    
    private func handleInput(_ entryPoint: EntryPoint) {
        self.entryPoint = entryPoint
        
        switch entryPoint {
        case .present:
            configureByPresent()
        case .push:
            configureByPush()
        }
    }
}
// MARK: -Configure-
private extension SettingsNicknameViewController {
    private func configureByPresent() {
        configurePresentSubview()
        configurePresentLayout()
        configurePresentView()
    }
    
    private func configureByPush() {
        configurePushSubview()
        configurePushLayout()
        configurePushView()
    }
    
    private func configurePresentSubview() {
        view.addSubviews(nicknameLabel, editButton, underlineView)
    }
    
    private func configurePushSubview() {
        view.addSubviews(nicknameLabel, editButton, underlineView, doneButton)
    }
    
    private func configurePresentLayout() {
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
    }
    
    private func configurePushLayout() {
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
    
    private func configurePresentView() {
        navigationItem.do {
            $0.title = "닉네임 설정"
            $0.backButtonTitle = ""
            $0.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
            $0.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
            $0.rightBarButtonItem?.isEnabled = false
        }
        
        view.backgroundColor = .Background
        
        nicknameLabel.text = UserDefaults.standard.string(forKey: "nickname") ?? ""
        
        editButton.do {
            var configuration = UIButton.Configuration.roundBordered()
            configuration.title = "편집"
            configuration.baseForegroundColor = .Label
            configuration.background.strokeColor = .Label
            $0.configuration = configuration
            
            $0.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        }
        
        underlineView.backgroundColor = .Label
    }
    
    private func configurePushView() {
        navigationItem.do {
            $0.title = "닉네임 설정"
            $0.backButtonTitle = ""
        }
        
        view.backgroundColor = .Background
        
        nicknameLabel.text = UserDefaults.standard.string(forKey: "nickname") ?? ""
        
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
            
            $0.isEnabled = false
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
        completeSettingsNickname()
        presentDismissHandler?()
        dismissButtonClicked()
    }
    
    @objc private func doneButtonClicked() {
        completeSettingsNickname()
    }
}
// MARK: -Nickname-
private extension SettingsNicknameViewController {
    private func pushSettingsNicknameDetailViewController() {
        let vc = SettingsNicknameDetailViewController().then {
            $0.inputNickname(nicknameLabel.text)
            $0.bindNicknameHandler(handler: handleNicknameHandler)
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleNicknameHandler(_ result: (Result<String, NicknameError>)) {
        switch result {
        case .success(let nickname):
            updateNicknameLabel(nickname)
            updateDoneButton(to: true)
        case .failure(let error):
            updateNicknameLabel(error.text)
            showToast(error.kind.description)
        }
    }
    
    private func updateNicknameLabel(_ text: String?) {
        nicknameLabel.text = text
    }
    
    private func updateDoneButton(to status: Bool = false) {
        doneButton.isEnabled = status
        navigationItem.rightBarButtonItem?.isEnabled = status
    }
    
    private func completeSettingsNickname() {
        saveNickname(nicknameLabel.text)
        replaceRootViewController()
    }
    
    private func replaceRootViewController() {
        tabBarController?.replaceToMovie()
    }
    
    private func saveNickname(_ text: String?) {
        UserDefaults.standard.set(text, forKey: "nickname")
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
}
// MARK: -
