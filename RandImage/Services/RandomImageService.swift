//
//  IRandommageService.swift
//  RandImage
//
//  Created by Denys Rybas on 17.01.2023.
//

import Foundation

class RandomImageService {
    
    func fetchRandomImage(
        handler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return ImageAPI()
            .getRandomImageTask(completionHandler: handler)
    }
}
