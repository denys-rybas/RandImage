//
//  ImagesAPI.swift
//  RandImage
//
//  Created by Denys Rybas on 17.01.2023.
//

import UIKit

class ImageAPI {
    enum Endpoints: String {
        case randomImage = "/random/1200x800"
        
        func getHost() -> String {
            return "https://source.unsplash.com"
        }
        
        func url() -> URL {
            return URL(string: getHost() + self.rawValue)!
        }
    }
    
    func getRandomImageTask(
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return URLSession.shared
            .dataTask(with: Endpoints.randomImage.url(), completionHandler: completionHandler)
    }
}
