//
//  TapBarController.swift
//  TodoListApp
//
//  Created by aeroclub on 14.06.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabs() {
        
        let todoVC = ToDoListViewController()
        let todoNav = UINavigationController(rootViewController: todoVC)
        todoNav.tabBarItem = UITabBarItem(
            title: "Заметки",
            image: UIImage(systemName: "list.bullet"),
            tag: 0
        )
        
        let settingsVC = UIViewController()
        settingsVC.view.backgroundColor = .systemBackground
        settingsVC.title = "Настройки"
        let settingsNav = UINavigationController(rootViewController: settingsVC)
        settingsNav.tabBarItem = UITabBarItem(
            title: "Настройки",
            image: UIImage(systemName: "gear"),
            tag: 1
        )
        
        viewControllers = [todoNav, settingsNav]
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .systemBackground
    }
}
