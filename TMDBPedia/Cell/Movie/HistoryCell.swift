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
        collectionView.reloadData()
    }
}
// MARK: -Configure-
private extension HistoryCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
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
    
    private func configureView() {
        
    }
}
// MARK: -CollectionView-
extension HistoryCell: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.do {
            let layout = UICollectionViewFlowLayout().then {
                $0.itemSize = CGSize(width: 60, height: 30)
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
        
        return cell
    }
}
// MARK: -

// MARK: -HistoryContentCell-
final class HistoryContentCell: BaseCollecctionViewCell {
    private let keywordLabel = UILabel()
    private let deleteButton = UIButton()
    
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
        contentView.addSubviews(keywordLabel, deleteButton)
    }
    
    private func configureLayout() {
        keywordLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        deleteButton.snp.makeConstraints {
            $0.trailing.centerY.equalToSuperview()
        }
    }
    
    private func configureView() {
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    }
}
// MARK: -
