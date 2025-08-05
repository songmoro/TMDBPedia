//
//  HistoryCell.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/2/25.
//

import UIKit
import SnapKit
import Then

// MARK: -HistoryCell-
final class HistoryCell: BaseTableViewCell {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var keywords: [String] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
}
// MARK: -Open-
extension HistoryCell {
    public func input(_ keywords: [String]) {
        self.keywords = keywords
    }
    
    public func needsReload() {
        collectionView.reloadData()
    }
}
// MARK: -Configure-
private extension HistoryCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureCollectionView()
    }
    
    private func configureSubview() {
        contentView.addSubview(collectionView)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
// MARK: -CollectionView-
extension HistoryCell: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.do {
            let layout = UICollectionViewFlowLayout().then {
                $0.itemSize = CGSize(width: 120, height: 30)
                $0.minimumLineSpacing = CGFloat(Constant.offsetFromHorizon)
                $0.minimumInteritemSpacing = 0
                $0.scrollDirection = .horizontal
            }
            
            $0.delegate = self
            $0.dataSource = self
            $0.register(HistoryContentCell.self)
            $0.collectionViewLayout = layout
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        keywords.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HistoryContentCell.self, for: indexPath)
        let keyword = keywords[indexPath.item]
        
        cell.input(keyword)
        cell.keywordButton.do {
            $0.update(indexPath)
            $0.addTarget(self, action: #selector(postIndexPathForPushMovieSearchViewController), for: .touchUpInside)
        }
        
        cell.deleteButton.do {
            $0.update(indexPath)
            $0.addTarget(self, action: #selector(postIndexPathForRemoveKeyword), for: .touchUpInside)
        }
        
        return cell
    }
    
    @objc private func postIndexPathForRemoveKeyword(_ sender: WithIndexPathButton) {
        NotificationCenter.default.post(name: .forName(.removeKeyword), object: nil, userInfo: ["indexPath": sender.indexPath])
    }
    
    @objc private func postIndexPathForPushMovieSearchViewController(_ sender: WithIndexPathButton) {
        NotificationCenter.default.post(name: .forName(.pushMovieSearchViewController), object: nil, userInfo: ["indexPath": sender.indexPath])
    }
}
// MARK: -

// MARK: -HistoryContentCell-
final class HistoryContentCell: BaseCollectionViewCell {
    let keywordButton = WithIndexPathButton()
    private let keywordLabel = UILabel()
    let deleteButton = WithIndexPathButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}
// MARK: -Open-
extension HistoryContentCell {
    public func input(_ keyword: String) {
        keywordLabel.text = keyword
    }
}
// MARK: -Configure-
private extension HistoryContentCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        keywordButton.addSubviews(keywordLabel, deleteButton)
        contentView.addSubview(keywordButton)
    }
    
    private func configureLayout() {
        keywordButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        keywordLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Constant.offsetFromHorizon)
        }
        
        deleteButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        deleteButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(keywordLabel.snp.trailing).offset(Constant.offsetFromTop).priority(1000)
            $0.trailing.equalToSuperview().inset(Constant.offsetFromHorizon).priority(1000)
        }
    }
    
    private func configureView() {
        keywordButton.do {
            var configuration = UIButton.Configuration.roundBordered()
            configuration.background.backgroundColor = .Label
            configuration.background.strokeWidth = 0
            
            $0.configuration = configuration
        }
        
        keywordLabel.do {
            $0.textColor = .Background
            $0.textAlignment = .center
        }
        
        deleteButton.do {
            var configuration = UIButton.Configuration.plain()
            configuration.image = UIImage(systemName: "xmark")
            configuration.baseForegroundColor = .Background
            configuration.buttonSize = .mini
            configuration.contentInsets = .zero
            
            $0.configuration = configuration
        }
    }
}
// MARK: -
