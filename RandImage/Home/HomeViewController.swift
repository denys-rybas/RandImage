//
//  ViewController.swift
//  RandImage
//
//  Created by Denys Rybas on 10.01.2023.
//

import UIKit
import CoreImage.CIFilterBuiltins

class HomeViewController: UIViewController {
    // MARK: - View elements
    var backgroundImageView = UIImageView()
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    var nextImageButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.showsActivityIndicator = false
        
        let button = UIButton(configuration: configuration)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        button.setTitle("Next photo", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    var saveImageButton: UIButton = {
        let button = UIButton()
        let icon: UIImage = UIImage(systemName: "arrow.down.circle")!
        button.setImage(icon, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 5
        return button
    }()
    var segmentBottomNavigation: UISegmentedControl = {
        let items = ["Main", "History"]
        let control = UISegmentedControl(items: items)
        control.backgroundColor = .white
        control.selectedSegmentIndex = 0
        return control
    }()
    // MARK: - Other variables
    var isImageLoaded: Bool = false {
        didSet {
            saveImageButton.isEnabled = isImageLoaded
        }
    }
    
    // MARK: - Lifecycle
    override func loadView() {
         super.loadView()
        // TODO: self.view = HomeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Random Photo"
        
        // TODO: - move all to view
        // TODO: - check MVP (p - presenter)
        // TODO: - check autolayout
        // TODO: - check UIStackView
        // TODO: - Codable
        
        UserDefaults.standard.setValue(<#T##value: Any?##Any?#>, forKey: <#T##String#>)
        
        view.addSubview(backgroundImageView)
        view.addSubview(imageView)
        view.addSubview(nextImageButton)
        view.addSubview(saveImageButton)
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.frame = view.frame
        
        view.backgroundColor = .systemBackground
        
        nextImageButton.frame = CGRect(
            x: 30,
            y: view.frame.size.height - 170,
            width: view.frame.size.width - 150,
            height: 55
        )
        nextImageButton.addTarget(
            self,
            action: #selector(loadNewImage),
            for: .touchUpInside
        )
        
        // Add handler for image view
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(openImageToFullScreen)
        )
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        imageView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: 500
        )
        
        saveImageButton.frame = CGRect(
            x: nextImageButton.frame.width + 60,
            y: view.frame.size.height - 170,
            width: 55,
            height: 55)
        saveImageButton.addTarget(
            self,
            action: #selector(saveImage),
            for: .touchUpInside
        )
        
        setRandomPhoto()
    }
    
    override func viewDidLayoutSubviews() {
        // view.safeAreaInsets are not available in viewDidLoad
    }
    
    // MARK: - Handlers
    @objc func loadNewImage() {
        // Start loader on button
        nextImageButton.configuration?.showsActivityIndicator = true
        nextImageButton.isEnabled = false
        
        setRandomPhoto()
    }
    
    @objc func openImageToFullScreen(_ recognizer: UITapGestureRecognizer) -> Void {
        let fullImageView = UIImageView()
        let originalView = recognizer.view as! UIImageView
        
        fullImageView.image = originalView.image
        fullImageView.frame = UIScreen.main.bounds
        fullImageView.backgroundColor = .black
        fullImageView.contentMode = .scaleAspectFit
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(exitFromFullScreenImage)
        )
        
        fullImageView.addGestureRecognizer(tap)
        fullImageView.isUserInteractionEnabled = true
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(fullImageView)
    }
    
    @objc func exitFromFullScreenImage(_ sender: UITapGestureRecognizer) -> Void {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        sender.view?.removeFromSuperview()
    }
    
    @objc func saveImage() -> Void {
        UIImageWriteToSavedPhotosAlbum(self.imageView.image!, nil, nil, nil)
    }
    
    // MARK: - Methods
    func setRandomPhoto() -> Void {
        let urlString = "https://source.unsplash.com/random/1200x800"
        let url = URL(string: urlString)!
        
        self.isImageLoaded = false
        
        let task: URLSessionDataTask = URLSession.shared
            .dataTask(with: url) { data, response, error in
                if let data = data {
                    // UI code should be in the main thread
                    DispatchQueue.main.async {
                        // Position
                        var viewCenter = self.view.center
                        viewCenter.y = viewCenter.y - 25
                        self.imageView.center = viewCenter
                        // Set image
                        let image = UIImage(data: data)
                        self.imageView.image = image
                        
                        self.addBlurredBackground(image!, blurRradius: 10.0)
                        
                        // Stop loader on button
                        self.nextImageButton.configuration?.showsActivityIndicator = false
                        self.nextImageButton.isEnabled = true
                        
                        // Image loaded -> can save the image
                        self.isImageLoaded = true
                    }
                } else if let error = error {
                    print(error)
                }
            }
        task.resume()
    }
    
    private func addBlurredBackground(_ image: UIImage, blurRradius: Float) {
        let ciImage = CIImage(image: image)
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = ciImage
        blurFilter.radius = blurRradius
        var output = blurFilter.outputImage
        
        let test = CIFilter.exposureAdjust()
        test.ev = -4.0
        test.inputImage = output
        output = test.outputImage
                        
        self.backgroundImageView.image = UIImage(ciImage: output!)
    }
}
