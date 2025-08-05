//
//  SettingsViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import SnapKit
import Then

// MARK: -SettingsViewController-
final class SettingsViewController: BaseViewController {
    private let profileView = ProfileView()
    private let tableView = UITableView()
    
    private let list = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let nickname = Nickname.get() else { return }
        profileView.updateNicknameLabel(nickname.text)
    }
}
// MARK: -Configure-
private extension SettingsViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureNavigation()
        configureTableView()
    }
    
    private func configureSubview() {
        view.addSubviews(profileView, tableView)
    }
    
    private func configureLayout() {
        profileView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide).inset(Constant.offsetFromHorizon)
            $0.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(Constant.offsetFromRelated)
            $0.horizontalEdges.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .Background
        tableView.backgroundColor = .Background
        
        profileView.do {
            let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(settingsNickname))
            $0.addGestureRecognizer(tapGestrue)
        }
    }
    
    private func configureNavigation() {
        navigationItem.title = "설정"
    }
    
    @objc private func settingsNickname() {
        let settingsNicknameViewContoller = SettingsNicknameViewController().then {
            $0.bind(dismissHandler: updateNicknameLabel)
        }
        
        let navigationController = UINavigationController(rootViewController: settingsNicknameViewContoller)
        present(navigationController, animated: true)
    }
    
    private func updateNicknameLabel(_ newNickname: Nickname) {
        profileView.updateNicknameLabel(newNickname.text)
    }
}
// MARK: -TableView-
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.textColor = .Label
        cell.backgroundColor = .Background
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            handleWithdrawFromAccount()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        indexPath.row == 3 ? indexPath : nil
    }
    
    private func handleWithdrawFromAccount() {
        UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert).then {
            $0.overrideUserInterfaceStyle = .dark
            $0.addAction(UIAlertAction(title: "취소", style: .cancel))
            $0.addAction(UIAlertAction(title: "확인", style: .destructive, handler: withdraw))
        }
        .do {
            present($0, animated: true)
        }
    }
    
    private func withdraw(_: UIAlertAction) {
        UserDefaultsManager.shared.remove(.likeList)
        UserDefaultsManager.shared.remove(.keywords)
        UserDefaultsManager.shared.remove(.nickname)
        
        tabBarController?.replaceToOnboarding()
    }
}
// MARK: -
