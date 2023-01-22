//
//  ImageCell.swift
//  RandImage
//
//  Created by Denys Rybas on 21.01.2023.
//

import UIKit

class HistoryImageCell: UICollectionViewCell {
    static let identifier = "HistoryImageCell"
    var model: RandomImage?
    
    private let imageView: UIImageView = {
       let imagageView = UIImageView()
        imagageView.contentMode = .scaleAspectFill
        imagageView.clipsToBounds = true
        return imagageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
                
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    override func layoutSubviews() {
        imageView.image = model?.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
