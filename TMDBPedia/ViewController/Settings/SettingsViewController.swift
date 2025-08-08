//
//  SettingsViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import Combine
import SnapKit
import Then

// MARK: -SettingsViewController-
final class SettingsViewController: BaseViewController {
    private var cancellable = Set<AnyCancellable>()
    private let profileView = ProfileView()
    private let tableView = UITableView()
    private var nickname: Nickname = .init(text: "")
    
    private let list = ["자주 묻는 질문", "1:1 문의", "알림 설정", "탈퇴하기"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
        configure()
    }
}
// MARK: -Configure-
private extension SettingsViewController {
    private func bind() {
        UserDefaultsManager.shared.$nickname
            .compactMap(\.self)
            .handleEvents(receiveOutput: {
                self.profileView.inputNickname($0)
            })
            .assign(to: \.nickname, on: self)
            .store(in: &cancellable)
        
        UserDefaultsManager.shared.$likeList
            .replaceNil(with: [])
            .sink {
                self.profileView.inputLikeList($0.count)
            }
            .store(in: &cancellable)
    }
    
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureTableView()
    }
    
    private func configureSubview() {
        [profileView, tableView].forEach(view.addSubview)
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
        navigationItem.title = "설정"
        
        profileView.do {
            let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(settingsNickname))
            $0.addGestureRecognizer(tapGestrue)
        }
    }
    
    @objc private func settingsNickname() {
        let settingsNicknameViewContoller = SettingsNicknameViewController().then {
            $0.inputNickname(self.nickname)
        }
        
        let navigationController = UINavigationController(rootViewController: settingsNicknameViewContoller)
        present(navigationController, animated: true)
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
        UserDefaultsManager.shared.likeList = nil
        UserDefaultsManager.shared.keywords = nil
        UserDefaultsManager.shared.nickname = nil
        
        tabBarController?.replaceToOnboarding()
    }
}
// MARK: -
