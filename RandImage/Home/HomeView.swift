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
//    struct Props {
//        let image: UIImage
//    }
    
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
        
        backgroundColor = .systemBrown
        
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
        NSLayoutConstraint.activate([
            // make bg full screen
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            // center image view
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            nextImageButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            nextImageButton.heightAnchor.constraint(equalToConstant: 50),
            nextImageButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 40),
            nextImageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            
            saveImageButton.widthAnchor.constraint(equalTo: nextImageButton.widthAnchor, multiplier: 0.25),
            saveImageButton.heightAnchor.constraint(equalTo: nextImageButton.heightAnchor),
            saveImageButton.topAnchor.constraint(equalTo: nextImageButton.topAnchor),
            saveImageButton.leadingAnchor.constraint(equalTo: nextImageButton.trailingAnchor, constant: 10),
            saveImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    private func setupBackground() {
        addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
        nextButton.translatesAutoresizingMaskIntoConstraints = false
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
        saveImageButton.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        fullImageView.translatesAutoresizingMaskIntoConstraints = false
        fullImageView.image = image
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
        
        activeteFullScreenImageConstraints(fullImageView)
    }
    
    private func activeteFullScreenImageConstraints(_ view: UIImageView) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
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
