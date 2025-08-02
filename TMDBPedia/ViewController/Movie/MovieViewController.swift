//
//  MovieViewController.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/1/25.
//

import UIKit
import SnapKit
import Then

final class MovieViewController: UIViewController {
    private let headerView = UIView()
    private let nicknameLabel = UILabel()
    private let registerDateLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let storageButton = UIButton()
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: Configure
private extension MovieViewController {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureNavigation()
        configureTableView()
    }
    
    private func configureSubview() {
        headerView.addSubviews(nicknameLabel, registerDateLabel, chevronImageView, storageButton)
        view.addSubviews(headerView, tableView)
    }
    
    private func configureLayout() {
        headerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview(\.safeAreaLayoutGuide).inset(Constant.offsetFromHorizon)
            $0.height.equalTo(100)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(Constant.offsetFromHorizon)
        }
        
        chevronImageView.snp.makeConstraints {
            $0.verticalEdges.equalTo(nicknameLabel)
            $0.trailing.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
        
        registerDateLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(nicknameLabel)
            $0.trailing.equalTo(chevronImageView.snp.leading).inset(-Constant.offsetFromHorizon)
        }
        
        storageButton.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(Constant.offsetFromHorizon)
            $0.horizontalEdges.bottom.equalToSuperview().inset(Constant.semiOffsetFromHorizon)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(Constant.offsetFromRelated)
            $0.horizontalEdges.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        view.backgroundColor = .Background
        
        headerView.do {
            $0.backgroundColor = .systemGray5
            $0.layer.cornerRadius = Constant.defaultRadius
        }
        
        nicknameLabel.do {
            $0.text = UserDefaults.standard.string(forKey: "nickname") ?? "닉네임 로딩 실패"
            $0.textColor = .Label
            $0.font = .systemFont(ofSize: Constant.headerSize, weight: .semibold)
        }
        
        chevronImageView.do {
            $0.image = UIImage(systemName: "chevron.right")
            $0.tintColor = .Fill
        }
        
        registerDateLabel.do {
            $0.text = "25.06.24 가입"
            $0.textColor = .Fill
            $0.font = .systemFont(ofSize: Constant.bodySize, weight: .light)
        }
        
        storageButton.do {
            var configuration = UIButton.Configuration.bordered()
            configuration.baseBackgroundColor = .Tint.withAlphaComponent(0.3)
            configuration.baseForegroundColor = .Label
            configuration.title = "0개의 무비박스 보관중"
            
            $0.configuration = configuration
        }
    }
    
    private func configureNavigation() {
        navigationItem.do {
            $0.title = "TMDBPedia"
            $0.setRightBarButton(UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil), animated: true)
        }
    }
}

// MARK: TableView
extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    private func configureTableView() {
        tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.isScrollEnabled = false
            $0.register(EmptyHistoryCell.self)
            $0.register(HistoryCell.self)
            $0.register(TodayMovieCell.self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
//            let cell = tableView.dequeueReusableCell(HistoryCell.self, for: indexPath)
            let cell = tableView.dequeueReusableCell(EmptyHistoryCell.self, for: indexPath)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(TodayMovieCell.self, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return CGFloat(Constant.textFieldHeight)
        }
        else {
            return UIScreen.main.bounds.height * 0.4
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerLabel = UILabel()
        headerLabel.do {
            if section == 0 {
                $0.text = "최근검색어"
            }
            else {
                $0.text = "오늘의 영화"
            }
            $0.font = .systemFont(ofSize: Constant.headerSize, weight: .bold)
        }
        
        return headerLabel
    }
}
