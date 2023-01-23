//
//  HistoryView.swift
//  RandImage
//
//  Created by Denys Rybas on 16.01.2023.
//

import UIKit

protocol HistoryViewDelegate: AnyObject, UICollectionViewDataSource {
    
}

class HistoryView: UIView {
    weak var delegate: HistoryViewDelegate?
    var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBrown
        
        setupCollectionView()
        setupConstraits()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        addSubview(collectionView)
    }
    
    private func setupConstraits() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1/2),
            heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let spacing: CGFloat = 2.5
        item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(1/1.5))
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
