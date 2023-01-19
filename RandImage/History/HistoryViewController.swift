//
//  HistoryViewController.swift
//  RandImage
//
//  Created by Denys Rybas on 11.01.2023.
//

import UIKit

class HistoryViewController: UIViewController, HistoryViewDelegate {
    
    let historyView = HistoryView()
    
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
}
