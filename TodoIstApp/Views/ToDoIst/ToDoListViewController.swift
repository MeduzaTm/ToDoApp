//
//  ViewController.swift
//  TodoListApp
//
//  Created by Нурик  Генджалиев   on 13.06.2025.
//

import UIKit

class ToDoListViewController: UIViewController, UITabBarDelegate {
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        
        search.searchBar.searchBarStyle = .prominent
        search.searchBar.delegate = self
        
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Заметки"
        navigationItem.largeTitleDisplayMode = .always
        view.backgroundColor = .systemBackground
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.searchBar.searchTextField.textColor = .white
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        setupUI()
    }
    
    private func setupUI() {
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            view.backgroundColor = .systemBackground
        }
    }
}

extension ToDoListViewController: UISearchBarDelegate {
    
}
