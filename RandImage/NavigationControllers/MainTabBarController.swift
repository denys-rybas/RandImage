//
//  MainTabBarController.swift
//  RandImage
//
//  Created by Denys Rybas on 15.01.2023.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .systemGray5
        
        let itemsData: [TabBarItemEnum] = [.home, .history]
        
        // Add view controllers
        let controllers = itemsData.map() {
            switch $0 {
            case .home:
                let homeController = HomeViewController()
                return UINavigationController(rootViewController: homeController)
            case .history:
                let historyController = HistoryViewController()
                return UINavigationController(rootViewController: historyController)
            }
        }
        
        setViewControllers(controllers, animated: false)
        
        // Modify tab bar item of each view contoller
        viewControllers?.enumerated().forEach() {
            $1.tabBarItem.title = itemsData[$0].title
            $1.tabBarItem.image = UIImage(systemName: itemsData[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(
                top: 5,
                left: 0,
                bottom: -5,
                right: 0
            )
        }
    }
    
}

private enum TabBarItemEnum: Int {
    case home
    case history
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .history:
            return "History"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .history:
            return "list.bullet.rectangle.portrait.fill"
        }
    }
}
