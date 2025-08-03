//
//  BackdropsCell.swift
//  TMDBPedia
//
//  Created by 송재훈 on 8/3/25.
//

import UIKit
import SnapKit
import Then

// MARK: -BackdropsCell-
final class BackdropsCell: UITableViewCell, IsIdentifiable {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let informationLabel = UILabel()
    private var backdrops = [BackdropsItem]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: -Open-
extension BackdropsCell {
    public func input(_ items: [BackdropsItem]) {
        self.backdrops = items
        collectionView.reloadData()
    }
}
// MARK: -Configure-
private extension BackdropsCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
        configureCollectionView()
    }
    
    private func configureSubview() {
        contentView.addSubviews(collectionView, informationLabel)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview().priority(1000)
            $0.height.equalTo(collectionView.snp.width).multipliedBy(0.8).priority(999)
            $0.top.horizontalEdges.equalToSuperview().inset(Constant.offsetFromHorizon).priority(998)
        }
        
        informationLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(Constant.offsetFromHorizon)
            $0.horizontalEdges.bottom.equalToSuperview().inset(Constant.offsetFromHorizon)
        }
    }
    
    private func configureView() {
        informationLabel.do {
            $0.textAlignment = .center
            $0.text = "abcdefg"
        }
    }
}
// MARK: -CollectionView-
extension BackdropsCell: UICollectionViewDelegate, UICollectionViewDataSource {
    private func configureCollectionView() {
        collectionView.do {
            $0.isPagingEnabled = true
            $0.delegate = self
            $0.dataSource = self
            $0.register(BackdropCell.self)
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        updateCollectionViewLayout()
    }
    
    private func updateCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout().then {
            let cellBounds = self.bounds
            
            $0.itemSize = cellBounds.size
            $0.minimumInteritemSpacing = 0
            $0.minimumLineSpacing = 0
            $0.scrollDirection = .horizontal
        }
        
        collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        min(backdrops.count, 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        cell = collectionView.dequeueReusableCell(BackdropCell.self, for: indexPath).then {
            let item = backdrops[indexPath.item]
            $0.input(item.file_path)
        }
        
        return cell
    }
}
// MARK: -
