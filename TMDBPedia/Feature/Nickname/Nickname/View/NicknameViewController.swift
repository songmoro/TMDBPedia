//
//  NicknameViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 7/31/25.
//

import UIKit
import SnapKit
import Combine

final class NicknameViewModel {
    @Published var nickname = Nickname(text: "")
    
    func validate() throws(NicknameError) {
        try nickname.validateNickname()
    }
    
    func saveNickname() {
        UserDefaultsManager.shared.nickname = nickname
    }
}

// MARK: -NicknameViewController-
final class NicknameViewController: BaseViewController {
    private var cancellable = Set<AnyCancellable>()
    private let viewModel = NicknameViewModel()
    
    private let nicknameLabel = UILabel()
    private let editButton: UIButton = {
        var configuration = UIButton.Configuration.roundBordered()
        configuration.title = "편집"
        configuration.baseForegroundColor = .Label
        configuration.background.strokeColor = .Label
        
        return UIButton(configuration: configuration)
    }()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .Label
        
        return view
    }()
    private let doneButton: UIButton = {
        var configuration = UIButton.Configuration.roundBordered()
        configuration.title = "완료"
        
        return UIButton(configuration: configuration)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configure()
    }
    
    private func bind() {
        viewModel.$nickname.sink { [weak self] in
            self?.nicknameLabel.text = $0.text
        }
        .store(in: &cancellable)
    }
    
    private func configure() {
        navigationItem.title = "닉네임 설정"
        navigationItem.backButtonTitle = ""
        
        [nicknameLabel, editButton, underlineView, doneButton].forEach(view.addSubview)
        
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
        
        editButton.addTarget(self, action: #selector(editButtonClicked), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneButtonClicked), for: .touchUpInside)
    }
    
    @objc private func dismissButtonClicked() {
        dismiss(animated: true)
    }
    
    @objc private func editButtonClicked() {
        let nicknameDetailVM = NicknameDetailViewModel(nickname: viewModel.nickname)
        
        let vc = NicknameDetailViewController()
        vc.inputViewModel(nicknameDetailVM) { [weak self] in
            self?.viewModel.nickname = $0
        }
        
        transition(vc, .push)
    }
    
    @objc private func saveButtonClicked() {
        do {
            try viewModel.validate()
            viewModel.saveNickname()
            dismissButtonClicked()
        }
        catch {
            showToast(error.kind.description)
        }
    }
    
    @objc private func doneButtonClicked() {
        do {
            try viewModel.validate()
            viewModel.saveNickname()
            replaceRootViewController()
        }
        catch {
            showToast(error.kind.description)
        }
    }
    
    private func replaceRootViewController() {
        tabBarController?.replaceToMovie()
    }
}
// MARK: -Open-
extension NicknameViewController {
    public func inputNickname(_ currentNickname: Nickname) {
        viewModel.nickname = currentNickname
        doneButton.isHidden = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
    }
}
// MARK: -
