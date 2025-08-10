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
final class BackdropsCell: BaseTableViewCell, IsIdentifiable {
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    private let pageControl = UIPageControl()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
}
// MARK: -Open-
extension BackdropsCell {
    public func setCollectionView(sectionAt tag: Int, cell: (UICollectionViewCell & IsIdentifiable).Type, size: CGSize, pages: Int, delegate: UICollectionViewDelegate & UICollectionViewDataSource) {
        collectionView.do {
            $0.tag = tag
            $0.delegate = delegate
            $0.dataSource = delegate
            
            let layout = UICollectionViewFlowLayout().then {
                $0.itemSize = bounds.size
                $0.minimumInteritemSpacing = 0
                $0.minimumLineSpacing = 0
                $0.scrollDirection = .horizontal
            }
            
            $0.collectionViewLayout = layout
            $0.register(cell)
            $0.reloadData()
        }
        
        pageControl.do {
            $0.currentPage = 0
            $0.numberOfPages = min(pages, 5)
        }
    }
}
// MARK: -Configure-
private extension BackdropsCell {
    private func configure() {
        configureSubview()
        configureLayout()
        configureView()
    }
    
    private func configureSubview() {
        [collectionView, pageControl].forEach(contentView.addSubview)
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
        collectionView.do {
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
        }
        
        pageControl.do {
            $0.currentPage = 0
        }
    }
}
// MARK: -
