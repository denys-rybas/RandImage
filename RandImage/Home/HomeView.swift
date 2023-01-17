//
//  HomeView.swift
//  RandImage
//
//  Created by Denys Rybas on 16.01.2023.
//

import UIKit
import CoreImage.CIFilterBuiltins

protocol HomeViewDelegate: AnyObject {
    func didUpdateFullScreenImageState(isHidden: Bool)
    func didTapNextButton()
    func didTapImage(image: UIImage)
    func didTapSaveImage(image: UIImage)
}

class HomeView: UIView {
    // Trying split responsibilities between view and controller
    weak var delegate: HomeViewDelegate?
    
    // MARK: - View elements
    var backgroundImageView = UIImageView()
    var imageView = UIImageView()
    var nextImageButton: UIButton!
    var saveImageButton = UIButton()
    // MARK: - Other variables
    var isImageLoaded: Bool = false {
        didSet {
            saveImageButton.isEnabled = isImageLoaded
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBackground
        
        setupBackground()
        setupImageView()
        setupNextImageButton()
        setupSaveButton()
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupLayout() {
        backgroundImageView.frame = self.frame
        nextImageButton.frame = CGRect(
            x: 30,
            y: self.frame.size.height - 170,
            width: self.frame.size.width - 150,
            height: 55
        )

        imageView.frame = CGRect(
            x: 0,
            y: 0,
            width: self.frame.width,
            height: 500
        )
        
        saveImageButton.frame = CGRect(
            x: nextImageButton.frame.width + 60,
            y: self.frame.size.height - 170,
            width: 55,
            height: 55)
    }
    
    private func setupBackground() {
        addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.contentMode = .scaleAspectFill
        
        // Add handler for image view
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(didTapImage)
        )
        
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
    }
    
    private func setupNextImageButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.showsActivityIndicator = false
        
        let nextButton = UIButton(configuration: configuration)
        nextButton.backgroundColor = .white
        nextButton.layer.cornerRadius = 5
        nextButton.setTitle("Next photo", for: .normal)
        nextButton.setTitleColor(.black, for: .normal)
        nextButton.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
        self.nextImageButton = nextButton
        
        addSubview(nextImageButton)
    }
    
    private func setupSaveButton() {
        addSubview(saveImageButton)
        
        let icon: UIImage = UIImage(systemName: "arrow.down.circle")!
        saveImageButton.setImage(icon, for: .normal)
        saveImageButton.backgroundColor = .white
        saveImageButton.layer.cornerRadius = 5
        saveImageButton.addTarget(
            self,
            action: #selector(didTapSaveImage),
            for: .touchUpInside
        )
    }
    
    func setStateOfNextImageButton(imageLoaded: Bool) {
        isImageLoaded = imageLoaded
        
        nextImageButton.configuration?.showsActivityIndicator = !imageLoaded
        nextImageButton.isEnabled = imageLoaded
    }
    
    func setRandomImage(_ image: UIImage) {
        var viewCenter = self.center
        viewCenter.y = viewCenter.y - 25
        self.imageView.center = viewCenter
        self.imageView.image = image
    }
    
    func setBackgroundImage(_ image: UIImage, blurRadius: Float) {
        let ciImage = CIImage(image: image)
        let blurFilter = CIFilter.gaussianBlur()
        blurFilter.inputImage = ciImage
        blurFilter.radius = blurRadius
        var output = blurFilter.outputImage
        
        let test = CIFilter.exposureAdjust()
        test.ev = -4.0
        test.inputImage = output
        output = test.outputImage
                        
        self.backgroundImageView.image = UIImage(ciImage: output!)
    }
    
    func showFullScreenImage(_ image: UIImage) {
        let fullImageView = UIImageView()
        
        fullImageView.image = image
        fullImageView.frame = UIScreen.main.bounds
        fullImageView.backgroundColor = .black
        fullImageView.contentMode = .scaleAspectFit
        
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(exitFromFullScreenImage)
        )
        
        fullImageView.addGestureRecognizer(tap)
        fullImageView.isUserInteractionEnabled = true
        
        delegate?.didUpdateFullScreenImageState(isHidden: true)
        
        addSubview(fullImageView)
    }
    
    @objc func exitFromFullScreenImage(_ sender: UITapGestureRecognizer) -> Void {
        delegate?.didUpdateFullScreenImageState(isHidden: false)
        sender.view?.removeFromSuperview()
    }
    
    // MARK: - Handlers
    @objc private func didTapImage() {
        guard let image = imageView.image else { return }
        delegate?.didTapImage(image: image)
    }
    
    @objc func didTapNextButton() {
        delegate?.didTapNextButton()
    }
    
    @objc func didTapSaveImage() {
        delegate?.didTapSaveImage(image: imageView.image!)
    }
}
