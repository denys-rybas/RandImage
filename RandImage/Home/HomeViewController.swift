//
//  ViewController.swift
//  RandImage
//
//  Created by Denys Rybas on 10.01.2023.
//

import UIKit

class HomeViewController: UIViewController, HomeViewDelegate {
    let homeView: HomeView = HomeView()
    let service = RandomImageService()
    var randomImage: RandomImage?
    
//    override func loadView() {
//        homeView.delegate = self
//        self.view = homeView
//    }
    
    deinit {
        NotificationCenter.default
            .removeObserver(self, name: NSNotification.Name.tappedHistoryImage, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Random Photo"
        
        // required option to use auto-layout
        homeView.translatesAutoresizingMaskIntoConstraints = false
        homeView.delegate = self
        view.addSubview(homeView)
        
        NSLayoutConstraint.activate([
            homeView.topAnchor.constraint(equalTo: view.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        didTapNextButton()
        
        // TODO: - check UIStackView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(didTapHistoryImage), name: NSNotification.Name.tappedHistoryImage, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // view.safeAreaInsets are not available in viewDidLoad
    }
    
    @objc private func didTapHistoryImage(_ notification: Notification) {
        let userInfo = notification.userInfo as? Dictionary<String, Int>
        guard let index = userInfo?["modelIndex"] else { return }
        
        let model = service.getModelByIndex(index)
        if let model = model {
            homeView.setImageFromHistory(model: model)
        }
    }
    
    func didUpdateFullScreenImageState(isHidden: Bool) {
        navigationController?.setNavigationBarHidden(isHidden, animated: false)
    }
    
    func didTapNextButton() {
        // Start loader
        homeView.setStateOfNextImageButton(imageLoaded: false)
        homeView.updateStateOfSaveButton(wasSaved: false)
        let task = service
            .fetchRandomImage() { [weak self] data, response, error in
                guard let self = self else { return }
                
                if let data = data {
                    // UI code should be in the main thread
                    DispatchQueue.main.async {
                        let image = UIImage(data: data)
                        guard let image = image else { return }
                        
                        let randomImage = RandomImage(date: Date(), imageData: data)
                        self.randomImage = randomImage
                        
                        self.homeView.setRandomImage(image)
                        self.homeView.setBackgroundImage(image, blurRadius: 5.0)
                        // Stop loader on button
                        self.homeView.setStateOfNextImageButton(imageLoaded: true)
                        
                        self.service.saveToDefaults(randomImage)
                    }
                } else if let error = error {
                    print(error)
                }
            }
        task?.resume()
    }
    
    func didTapImage(image: UIImage) {
        homeView.showFullScreenImage(image)
    }
    
    func didTapSaveImage(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSavingHandler), nil)
    }
    
    @objc func imageSavingHandler(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            homeView.updateStateOfSaveButton(wasSaved: false)
            UIDevice().playHaptic(.error)
            
            let alertController = UIAlertController(title: "Error on save", message: error.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            
            return
        }
        
        homeView.updateStateOfSaveButton(wasSaved: true)
        UIDevice().playHaptic(.success)
    }
}
