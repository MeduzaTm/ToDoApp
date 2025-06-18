//
//  TapBarController.swift
//  TodoListApp
//
//  Created by aeroclub on 14.06.2025.
//

import UIKit

protocol MainTabBarControllerDelegate: AnyObject {
    func didTapAddButton()
}

final class MainTabBarController: UITabBarController {
    
    weak var addDelegate: MainTabBarControllerDelegate?
    private var viewModel = ToDoViewModel()
    private var mainVC = ToDoIstViewController()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 17, weight: .regular)
        return label
    }()
    
    private lazy var addButton: UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
        let buttonImage = UIImage(systemName: "square.and.pencil", withConfiguration: symbolConfig)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(addToDo), for: .touchUpInside)
        button.tintColor = .systemYellow
        return button
    }()
    
    let customTabBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        view.layer.shadowRadius = 4
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        hideSystemTabBar()
        updateTasksCount()
    }
    
    private func setupTabs() {
        let todoVC = ToDoIstViewController()
        viewControllers = [todoVC]
        todoVC.viewModel.delegate = self
        
        view.addSubview(customTabBar)
        customTabBar.addSubview(titleLabel)
        customTabBar.addSubview(addButton)
        
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
    
    private func hideSystemTabBar() {
        tabBar.isHidden = true
    }
    
    @objc private func addToDo() {
        addDelegate?.didTapAddButton()
    }
    
    func showCustomTabBar() {
        customTabBar.isHidden = false
    }
    
    func hideCustomTabBar() {
        customTabBar.isHidden = true
    }
    
    private func updateTasksCount() {
        let count = viewModel.toDos.count
        titleLabel.text = count == 0 ? "No tasks" : "\(count) tasks"
    }
}

extension MainTabBarController: ToDoViewModelDelegate {
    func didUpdateTasksCount(count: Int) {
        DispatchQueue.main.async {
            self.titleLabel.text = count == 0 ? "No tasks" : "\(count) tasks"
        }
    }
}
