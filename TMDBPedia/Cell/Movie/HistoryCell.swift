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
final class HistoryCell: UITableViewCell {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HistoryContentCell.self, for: indexPath)
        
        return cell
    }
}
// MARK: -

// MARK: -HistoryContentCell-
final class HistoryContentCell: UICollectionViewCell {
    private let keywordLabel = UILabel()
    private let deleteButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
        keywordLabel.text = "하얼빈"
        deleteButton.setImage(UIImage(systemName: "xmark"), for: .normal)
    }
}
// MARK: -
