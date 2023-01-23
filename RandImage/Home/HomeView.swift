//
//  HomeView.swift
//  RandImage
//
//  Created by Denys Rybas on 16.01.2023.
//

import UIKit

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
    var backgroundBlurEffectView = UIVisualEffectView()
    var imageView = UIImageView()
    var nextImageButton = UIButton()
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
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupConstraints() {
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundBlurEffectView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nextImageButton.translatesAutoresizingMaskIntoConstraints = false
        saveImageButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // make bg full screen
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            backgroundBlurEffectView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor),
            backgroundBlurEffectView.leadingAnchor.constraint(equalTo: backgroundImageView.leadingAnchor),
            backgroundBlurEffectView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
            backgroundBlurEffectView.trailingAnchor.constraint(equalTo: backgroundImageView.trailingAnchor),
            
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
            saveImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
    
    private func setupBackground() {
        addSubview(backgroundImageView)
        addSubview(backgroundBlurEffectView)
        
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundBlurEffectView.contentMode = .scaleAspectFill
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
        addSubview(nextImageButton)

        var configuration = UIButton.Configuration.plain()
        configuration.showsActivityIndicator = false
        
        nextImageButton.configuration = configuration
        nextImageButton.translatesAutoresizingMaskIntoConstraints = false
        nextImageButton.backgroundColor = .white
        nextImageButton.layer.cornerRadius = 5
        nextImageButton.setTitle("Next photo", for: .normal)
        nextImageButton.setTitleColor(.black, for: .normal)
        nextImageButton.addTarget(
            self,
            action: #selector(didTapNextButton),
            for: .touchUpInside
        )
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
        self.imageView.image = image
    }
    
    func setBackgroundImage(_ image: UIImage, blurRadius: Float) {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        self.backgroundBlurEffectView.effect = blurEffect
                        
        self.backgroundImageView.image = image
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
