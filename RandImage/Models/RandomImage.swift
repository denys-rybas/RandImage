//
//  RandomPhoto.swift
//  RandImage
//
//  Created by Denys Rybas on 17.01.2023.
//

import UIKit

struct RandomImage: Codable {
    let date: Date
    let imageData: Data
    
    var image: UIImage? {
        return UIImage(data: self.imageData)
    }
    
}
