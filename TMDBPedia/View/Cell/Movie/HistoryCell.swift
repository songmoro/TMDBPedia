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
final class HistoryCell: BaseTableViewCell, IsIdentifiable {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
}
// MARK: -Open-
extension HistoryCell {
    public func setCollectionView(sectionAt tag: Int, cell: (UICollectionViewCell & IsIdentifiable).Type, delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        collectionView.do {
            $0.tag = tag
            $0.delegate = delegate
            $0.dataSource = delegate
            $0.register(cell)
            $0.reloadData()
        }
    }
}
// MARK: -Configure-
private extension HistoryCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
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
        collectionView.do {
            let layout = UICollectionViewFlowLayout().then {
                $0.itemSize = CGSize(width: 120, height: 30)
                $0.minimumLineSpacing = CGFloat(Constant.offsetFromHorizon)
                $0.minimumInteritemSpacing = 0
                $0.scrollDirection = .horizontal
            }
            
            $0.backgroundColor = .Background
            $0.collectionViewLayout = layout
        }
    }
}
// MARK: -

// MARK: -HistoryContentCell-
final class HistoryContentCell: BaseCollectionViewCell, IsIdentifiable {
    private let keywordButton = WithIndexPathButton()
    private let keywordLabel = UILabel()
    private let deleteButton = WithIndexPathButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
}
// MARK: -Open-
extension HistoryContentCell {
    public func input(_ keyword: Keyword) {
        keywordLabel.text = keyword.text
    }
    
    public func updateKeywordButton(_ indexPath: IndexPath, _ selector: Selector) {
        keywordButton.indexPath = indexPath
        keywordButton.addTarget(nil, action: selector, for: .touchUpInside)
    }
    
    public func updateDeletaButton(_ indexPath: IndexPath, _ selector: Selector) {
        deleteButton.indexPath = indexPath
        deleteButton.addTarget(nil, action: selector, for: .touchUpInside)
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
        [keywordLabel, deleteButton].forEach(keywordButton.addSubview)
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
