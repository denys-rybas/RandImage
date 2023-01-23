//
//  ImagesAPI.swift
//  RandImage
//
//  Created by Denys Rybas on 17.01.2023.
//

import UIKit

class ImageAPI {
    enum Endpoints: String {
        case randomImage = "/random/1920x1080"
        
        func getHost() -> String {
            return "https://source.unsplash.com"
        }
        
        func url() -> URL? {
            return URL(string: getHost() + self.rawValue)
        }
    }
    
    func getRandomImageTask(
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask? {
        guard let url = Endpoints.randomImage.url() else { return nil }
        
        return URLSession
            .shared
            .dataTask(with: url, completionHandler: completionHandler)
    }
}
