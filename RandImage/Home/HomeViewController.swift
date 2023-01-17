//
//  ViewController.swift
//  RandImage
//
//  Created by Denys Rybas on 10.01.2023.
//

import UIKit

class HomeViewController: UIViewController, HomeViewDelegate {
    let homeView: HomeView = HomeView(frame: UIScreen.main.bounds)
    
    override func loadView() {
        homeView.delegate = self
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Random Photo"
        
        didTapNextButton()
        
        // TODO: - check autolayout
        // TODO: - check UIStackView
        // TODO: - Codable
        // TODO: - UserDefaults.standard.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        // in debug mode we can use "po" (print object) in console
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // view.safeAreaInsets are not available in viewDidLoad
    }
    
    func didUpdateFullScreenImageState(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
    }
    
    func didTapNextButton() {
        // Start loader
        homeView.setStateOfNextImageButton(imageLoaded: false)

        let urlString = "https://source.unsplash.com/random/1200x800"
        let url = URL(string: urlString)!
                        
        let task: URLSessionDataTask = URLSession.shared
            .dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let data = data {
                    // UI code should be in the main thread
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.homeView.setRandomImage(image!)
                        self.homeView.setBackgroundImage(image!, blurRadius: 5.0)
                        // Stop loader on button
                        self.homeView.setStateOfNextImageButton(imageLoaded: true)
                    }
                } else if let error = error {
                    print(error)
                }
            }
        task.resume()
    }
    
    func didTapImage(image: UIImage) {
        homeView.showFullScreenImage(image)
    }
    
    func didTapSaveImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
