//
//  SettingsNicknameDetailViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Then

final class SettingsNicknameDetailViewController: UIViewController {
    private let nicknameTextField = UITextField()
    private var stringHandler: ((String) -> ())?
    
    private let underlineView = UIView()
    private let statusLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isAvailableNickname(nicknameTextField) {
            stringHandler?(nicknameTextField.text!)
        }
    }
}

// MARK: Configure
private extension SettingsNicknameDetailViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureTextField()
    }
    
    private func configureSubview() {
        view.addSubviews(nicknameTextField, underlineView, statusLabel)
    }
    
    private func configureLayout() {
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
    
    private func configureView() {
        navigationItem.title = "닉네임 설정"
        
        view.backgroundColor = .Background
        
        underlineView.backgroundColor = .Label
        
        nicknameTextField.placeholder = "닉네임을 입력해주세요."
        
        statusLabel.do {
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = .Tint
        }
    }
}

// MARK: Open
extension SettingsNicknameDetailViewController {
    public func bindStringHandler(handler: @escaping (String) -> Void) {
        stringHandler = handler
    }
}

// MARK: TextField
private extension SettingsNicknameDetailViewController {
    private func configureTextField() {
        nicknameTextField.addTarget(self, action: #selector(isAvailableNickname), for: .editingChanged)
    }
    
    @objc private func isAvailableNickname(_ sender: UITextField) -> Bool {
        guard let text = sender.text else { return false }
        guard 2..<10 ~= text.count else {
            statusLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            return false
        }
        guard text.allSatisfy(\.isLetter) else {
            if text.contains(where: \.isNumber) {
                statusLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            }
            else {
                statusLabel.text = "닉네임에 @, #, $, % 는 포함할 수 없어요"
            }
            return false
        }
        
        statusLabel.text = "사용할 수 있는 닉네임이에요"
        return true
    }
}
