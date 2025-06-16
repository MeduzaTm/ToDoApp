//
//  TapBarController.swift
//  TodoListApp
//
//  Created by aeroclub on 14.06.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    private var viewModel = ToDoViewModel()
    
    private let titleLabel: UILabel = {
           let label = UILabel()
           label.translatesAutoresizingMaskIntoConstraints = false
           label.text = "22 tasks"
           label.textAlignment = .center
           label.font = .systemFont(ofSize: 17, weight: .regular)
           return label
       }()
       
       private let addButton: UIButton = {
           let button = UIButton(type: .system)
           let symbolConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .light, scale: .default)
           let buttonImage = UIImage(systemName: "square.and.pencil", withConfiguration: symbolConfig)
           button.translatesAutoresizingMaskIntoConstraints = false
           button.setImage(buttonImage, for: .normal)
           button.addTarget(self, action: #selector(addToDo), for: .touchUpInside)
           button.tintColor = .systemYellow
           return button
       }()
       
        let customTabBar: UIView = {
           let customTabBar = UIView()
           customTabBar.backgroundColor = .systemBackground
           customTabBar.translatesAutoresizingMaskIntoConstraints = false
           customTabBar.layer.shadowColor = UIColor.black.cgColor
           customTabBar.layer.shadowOpacity = 0.1
           customTabBar.layer.shadowOffset = CGSize(width: 0, height: -2)
           customTabBar.layer.shadowRadius = 4
           return customTabBar
       }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupTabBarAppearance()
    }
    
    private func setupTabs() {
        view.addSubview(customTabBar)
        customTabBar.addSubview(titleLabel)
        customTabBar.addSubview(addButton)
        
        let todoVC = ToDoListViewController()
        let todoNav = UINavigationController(rootViewController: todoVC)
        
        viewControllers = [todoNav]
        
        NSLayoutConstraint.activate([
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.heightAnchor.constraint(equalToConstant: 80),
            
            titleLabel.centerXAnchor.constraint(equalTo: customTabBar.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: customTabBar.topAnchor, constant: 15),
            
            addButton.trailingAnchor.constraint(equalTo: customTabBar.trailingAnchor, constant: -15),
            addButton.topAnchor.constraint(equalTo: customTabBar.topAnchor, constant: 10),
            addButton.widthAnchor.constraint(equalToConstant: 30),
            addButton.heightAnchor.constraint(equalToConstant: 30)
            
        ])
    }
    
    private func setupTabBarAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .systemBackground
    }
    
    @objc func addToDo() {
        viewModel.addToDo(toDoItem: "New ToDo Item", isCompleted: false, title: "New ToDo")
    }
}
