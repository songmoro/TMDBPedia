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
final class BackdropsCell: BaseTableViewCell {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private var backdrops = [BackdropsItem]()
    private let pageControl = UIPageControl()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
}
// MARK: -Open-
extension BackdropsCell {
    public func input(_ items: [BackdropsItem]) {
        self.backdrops = items
        pageControl.numberOfPages = min(backdrops.count, 5)
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
        contentView.addSubviews(collectionView, pageControl)
    }
    
    private func configureLayout() {
        collectionView.snp.makeConstraints {
            $0.width.equalToSuperview().priority(1000)
            $0.height.equalTo(collectionView.snp.width).multipliedBy(0.8).priority(999)
            $0.edges.equalToSuperview().priority(998)
        }
        
        pageControl.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.horizontalEdges.bottom.equalToSuperview(\.safeAreaLayoutGuide)
        }
    }
    
    private func configureView() {
        backgroundColor = .Background
        
        pageControl.do {
            $0.currentPage = 0
            $0.numberOfPages = min(backdrops.count, 5)
        }
    }
}
// MARK: -CollectionView-
extension BackdropsCell: UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    private func configureCollectionView() {
        collectionView.do {
            $0.isPagingEnabled = true
            $0.delegate = self
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        pageControl.currentPage = index
    }
}
// MARK: -
