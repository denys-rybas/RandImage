//
//  IRandommageService.swift
//  RandImage
//
//  Created by Denys Rybas on 17.01.2023.
//

import Foundation

class RandomImageService {
    
    private let defaults = UserDefaults.standard
    private let defaultsKey = "random_images"
    
    func fetchRandomImage(
        handler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask {
        return ImageAPI()
            .getRandomImageTask(completionHandler: handler)
    }
        
    func saveToDefaults(_ randomImage: RandomImage) {
        guard let encodedImage = try? PropertyListEncoder().encode(randomImage) else { return }

        let defaultArray = [Data]()
        var images = defaults.array(forKey: defaultsKey) as? [Data] ?? defaultArray
        
        images = removedExtraImages(&images, maxCount: 5) // +1 new
        
        images.append(encodedImage)
        
        // workaround on how to update array in storage
        defaults.removeObject(forKey: defaultsKey)
        defaults.set(images, forKey: defaultsKey)
    }
    
    func fetchFromDefaults() -> [RandomImage] {
        guard let dataArray = defaults.array(forKey: defaultsKey) as? [Data] else {
            return [RandomImage]()
        }
        
        let mapped = dataArray.compactMap() { (item: Data) in
            return try? PropertyListDecoder().decode(RandomImage.self, from: item)
        }
        return mapped.sorted(by: {$0.date.compare($1.date) == .orderedDescending})
    }
    
    private func removedExtraImages(_ images: inout [Data], maxCount: Int) -> [Data] {
        let count: Int = images.count
        if count < maxCount {
            return images
        }
        
        images.removeFirst(count - maxCount)
        
        return images
    }
}
