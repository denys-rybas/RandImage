//
//  BottomNavigationView.swift
//  RandImage
//
//  Created by Denys Rybas on 14.01.2023.
//

import UIKit

class BottomNavigationView: UIView {
    
    var segmentBottomNavigation = UISegmentedControl()
    var selectedSegmentIndex: Int

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    init(frame: CGRect, index: Int) {
        self.selectedSegmentIndex = index
        super.init(frame: frame)
        
        setupSegmentControl()
        addSubview(segmentBottomNavigation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleSegmentButton (_ sender: UISegmentedControl) -> Void {
        let navigationController = getNavigationController()
        
        switch sender.selectedSegmentIndex {
        case 0:
            navigationController?.pushViewController(ViewController(), animated: false)
        case 1:
//            let historyController = HistoryViewController()
//            historyController.modalPresentationStyle = .fullScreen
//            self.present(historyController, animated: true)
            navigationController?.pushViewController(HistoryViewController(), animated: false)
        default:
            print("Unexpected index")
            return
        }
    }
    
    private func getNavigationController() -> UINavigationController? {
        let uiWindow = UIApplication
            .shared
            .connectedScenes
            .compactMap({($0 as? UIWindowScene)?.keyWindow})
            .first
        
        return uiWindow?.rootViewController as? UINavigationController
    }
    
    private func setupSegmentControl() {
        let items = ["Main", "History"]
        let control = UISegmentedControl(items: items)
        control.backgroundColor = .white
        control.selectedSegmentIndex = selectedSegmentIndex
        control.selectedSegmentTintColor = .lightText
        control.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        
        control.addTarget(self, action: #selector(handleSegmentButton), for: .valueChanged)
        
        self.segmentBottomNavigation = control
    }

}
