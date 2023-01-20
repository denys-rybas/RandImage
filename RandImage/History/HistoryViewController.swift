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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "My History"

        historyView.translatesAutoresizingMaskIntoConstraints = false
        historyView.delegate = self
        view.addSubview(historyView)
        
        NSLayoutConstraint.activate([
            historyView.topAnchor.constraint(equalTo: view.topAnchor),
            historyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            historyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            historyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // TODO: - Make collection view with last 6 images
    }
}

extension HistoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell(frame: .zero)
    }
}

extension HistoryViewController: UICollectionViewDelegate {
    
}
