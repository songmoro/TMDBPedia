//
//  SettingsViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import Combine
import SnapKit

// MARK: -SettingsViewController-
final class SettingsViewController: BaseViewController {
    private var cancellable = Set<AnyCancellable>()
    private let viewModel = SettingsViewModel()
    private let profileView = ProfileView()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configure()
    }
    
    private func bind() {
        viewModel.$nickname
            .sink(receiveValue: self.profileView.inputNickname)
            .store(in: &cancellable)
        
        viewModel.$likeList
            .map(\.count)
            .sink(receiveValue: self.profileView.inputLikeList)
            .store(in: &cancellable)
    }
    
    private func configure() {
        navigationItem.title = "설정"
        
        [profileView, tableView].forEach(view.addSubview)
        
        profileView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide).inset(Constant.offsetFromHorizon)
            $0.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileView.snp.bottom).offset(Constant.offsetFromRelated)
            $0.horizontalEdges.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
        
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(settingsNickname))
        profileView.addGestureRecognizer(tapGestrue)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc private func settingsNickname() {
        let settingsNicknameViewContoller = SettingsNicknameViewController()
        settingsNicknameViewContoller.inputNickname(viewModel.nickname)
        
        let navigationController = UINavigationController(rootViewController: settingsNicknameViewContoller)
        
        present(navigationController, animated: true)
    }
}
// MARK: -TableView-
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = viewModel.list[indexPath.row]
        cell.textLabel?.textColor = .Label
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        indexPath.row == 3 ? indexPath : nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            withdrawFromAccount()
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    private func withdrawFromAccount() {
        let alert = UIAlertController(title: "탈퇴하기", message: "탈퇴를 하면 데이터가 모두 초기화됩니다. 탈퇴 하시겠습니까?", preferredStyle: .alert)
        alert.overrideUserInterfaceStyle = .dark
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive) { [weak self] _ in
            self?.viewModel.withdraw()
            self?.tabBarController?.replaceToOnboarding()
        })
        
        present(alert, animated: true)
    }
}
// MARK: -
