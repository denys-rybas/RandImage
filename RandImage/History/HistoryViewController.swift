//
//  HistoryViewController.swift
//  RandImage
//
//  Created by Denys Rybas on 11.01.2023.
//

import UIKit

class HistoryViewController: UIViewController, HistoryViewDelegate {
    
    let historyView = HistoryView()
    let service = RandomImageService()
    var randomImages: [RandomImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My History"
        
        historyView.translatesAutoresizingMaskIntoConstraints = false
        historyView.delegate = self
        view.addSubview(historyView)
        
        historyView.collectionView.register(HistoryImageCell.self, forCellWithReuseIdentifier: HistoryImageCell.identifier)
        historyView.collectionView.dataSource = self
        
        NSLayoutConstraint.activate([
            historyView.topAnchor.constraint(equalTo: view.topAnchor),
            historyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            historyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        randomImages = service.fetchFromDefaults()
        historyView.collectionView.reloadData()
    }
}

extension HistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomImages?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = historyView.collectionView.dequeueReusableCell(
            withReuseIdentifier: HistoryImageCell.identifier, for: indexPath
        ) as? HistoryImageCell else { return HistoryImageCell() }
        
        let model = randomImages?[indexPath.row]
        cell.model = model
        
        return cell
    }
}

extension HistoryViewController: UICollectionViewDelegate {
    
}
