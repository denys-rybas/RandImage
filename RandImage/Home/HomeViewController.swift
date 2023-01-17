//
//  ViewController.swift
//  RandImage
//
//  Created by Denys Rybas on 10.01.2023.
//

import UIKit
import CoreImage.CIFilterBuiltins

class HomeViewController: UIViewController {
    
    override func loadView() {
//         super.loadView()
        let homeView: HomeView = HomeView(frame: UIScreen.main.bounds)
        homeView.controller = self
        self.view = homeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Random Photo"
        
        loadRandomImage()
        
        // TODO: - move all to view
        // TODO: - check MVP (p - presenter)
        // TODO: - check autolayout
        // TODO: - check UIStackView
        // TODO: - Codable
        // TODO: - UserDefaults.standard.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // view.safeAreaInsets are not available in viewDidLoad
    }
    
    // Because I can't override self.view to return HomeView
    private func getView() -> HomeView {
        return view as! HomeView
    }
    
    func toggleNavigationBarVisibility(hidden: Bool) {
        navigationController?.setNavigationBarHidden(hidden, animated: false)
    }
    
    func loadRandomImage() {
        // Start loader
        getView().setStateOfNextImageButton(imageLoaded: false)

        let urlString = "https://source.unsplash.com/random/1200x800"
        let url = URL(string: urlString)!
                        
        let task: URLSessionDataTask = URLSession.shared
            .dataTask(with: url) { data, response, error in
                if let data = data {
                    // UI code should be in the main thread
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        self.getView().setRandomImage(image!)
                        self.getView().setBackgroundImage(image!, blurRadius: 5.0)
                        // Stop loader on button
                        self.getView().setStateOfNextImageButton(imageLoaded: true)
                    }
                } else if let error = error {
                    print(error)
                }
            }
        task.resume()
    }
    
    func processFullScreenImage(_ sender: UITapGestureRecognizer) {
        getView().setFullScreenImage(sender: sender)
    }
    
    func saveImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
}
