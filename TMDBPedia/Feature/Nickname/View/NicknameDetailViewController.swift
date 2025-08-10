//
//  NicknameDetailViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit

// MARK: -NicknameDetailViewController-
final class NicknameDetailViewController: BaseViewController {
    private var nickname = Nickname(text: "")
    private let nicknameTextField: UITextField = {
        let attributedString = NSAttributedString(string: "닉네임을 입력해주세요.", attributes: [.foregroundColor: UIColor.Label])
        let textField = UITextField()
        textField.attributedPlaceholder = attributedString
        textField.textColor = .Label
        
        return textField
    }()
    private var nicknameHandler: ((Nickname) -> Void)?
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .Label
        
        return view
    }()
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.bodySize)
        label.textColor = .Tint
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        nicknameHandler?(nickname)
    }
    
    private func configure() {
        navigationItem.title = "닉네임 설정"
        
        [nicknameTextField, underlineView, statusLabel].forEach(view.addSubview)
        
        nicknameTextField.snp.makeConstraints {
            $0.top.leading.equalToSuperview(\.safeAreaLayoutGuide).offset(Constant.offsetFromVertical)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(Constant.textFieldHeight)
        }
        
        underlineView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(Constant.semiOffsetFromHorizon)
            $0.bottom.equalTo(nicknameTextField)
            $0.height.equalTo(1)
        }
        
        statusLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(Constant.semiOffsetFromHorizon)
            $0.horizontalEdges.equalTo(nicknameTextField)
        }
        
        nicknameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        handleNickname(text: sender.text)
    }
    
    private func handleNickname(text: String?)  {
        guard let text else { return }
        self.nickname.text = text
        
        do {
            try nickname.validateNickname()
            statusLabel.text = "사용할 수 있는 닉네임이에요"
        }
        catch {
            statusLabel.text = error.kind.description
        }
    }
}
// MARK: -Open-
extension NicknameDetailViewController {
    public func inputNickname(_ nickname: Nickname) {
        self.nickname = nickname
        nicknameTextField.text = nickname.text
    }
    
    public func bindNicknameHandler(handler: @escaping (Nickname) -> Void) {
        nicknameHandler = handler
    }
}
// MARK: -
