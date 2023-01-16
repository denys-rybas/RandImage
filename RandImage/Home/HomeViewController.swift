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
        self.view = HomeView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Random Photo"
        
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
}
