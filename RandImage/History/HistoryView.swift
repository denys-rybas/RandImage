//
//  HistoryView.swift
//  RandImage
//
//  Created by Denys Rybas on 16.01.2023.
//

import UIKit

protocol HistoryViewDelegate: AnyObject {
    
}

class HistoryView: UIView {
    weak var delegate: HistoryViewDelegate?
    var colletctionView: UICollectionView!
    
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
        colletctionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        addSubview(colletctionView)
    }
    
    private func setupConstraits() {
        colletctionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colletctionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            colletctionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            colletctionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            colletctionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(44))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
