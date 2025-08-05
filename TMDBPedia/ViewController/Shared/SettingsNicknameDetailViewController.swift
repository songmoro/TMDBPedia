//
//  SettingsNicknameDetailViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Then

// MARK: -SettingsNicknameDetailViewController-
final class SettingsNicknameDetailViewController: BaseViewController {
    private let nicknameTextField = UITextField()
    private var lastResult: Result<String, NicknameError>?
    private var nicknameHandler: ((Result<String, NicknameError>) -> ())?
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        passValidateNicknameResult()
    }
}
// MARK: -Open-
extension SettingsNicknameDetailViewController {
    public func inputNickname(_ text: String?) {
        nicknameTextField.text = text
    }
    
    public func bindNicknameHandler(handler: @escaping (Result<String, NicknameError>) -> Void) {
        nicknameHandler = handler
    }
}
// MARK: -Configure-
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
    }
    
    private func configureView() {
        navigationItem.title = "닉네임 설정"
        
        view.backgroundColor = .Background
        
        underlineView.backgroundColor = .Label
        
        nicknameTextField.do {
            let attributedString = NSAttributedString(string: "닉네임을 입력해주세요.", attributes: [.foregroundColor: UIColor.Label])
            
            $0.attributedPlaceholder = attributedString
            $0.textColor = .Label
        }
        
        statusLabel.do {
            $0.font = .systemFont(ofSize: Constant.bodySize)
            $0.textColor = .Tint
        }
    }
}
// MARK: -TextField-
extension SettingsNicknameDetailViewController {
    private func configureTextField() {
        nicknameTextField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
    }
    
    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        handleNickname(text: sender.text)
    }
    
    private func handleNickname(text: String?)  {
        let result = validateNickname(text: text)
        lastResult = result
        
        switch result {
        case .success:
            updateStatusLabel(text: "사용할 수 있는 닉네임이에요")
        case .failure(let error):
            updateStatusLabel(text: error.kind.description)
        }
    }
    
    private func validateNickname(text: String?) -> Result<String, NicknameError> {
        guard let text else {
            return .failure(NicknameError(text: nil, kind: .textIsNil))
        }
        guard 2..<10 ~= text.count else {
            return .failure(NicknameError(text: text, kind: .invalidRange))
        }
        guard !text.contains(where: \.isNumber) else {
            return .failure(NicknameError(text: text, kind: .containsNumber))
        }
        guard !text.contains(where: isLimitedSymbol) else {
            return .failure(NicknameError(text: text, kind: .containsSpecialSymbol))
        }
        
        return .success(text)
    }
    
    private func updateStatusLabel(text: String) {
        statusLabel.text = text
    }
    
    private func passValidateNicknameResult() {
        if let lastResult {
            nicknameHandler?(lastResult)
        }
    }
    
    private func isLimitedSymbol(_ character: Character) -> Bool {
        return "@#$%".contains(character)
    }
}
// MARK: -
