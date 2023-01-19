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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBrown
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
