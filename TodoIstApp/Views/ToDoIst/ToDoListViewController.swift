//
//  ViewController.swift
//  TodoListApp
//
//  Created by Нурик  Генджалиев   on 13.06.2025.
//

import UIKit

class ToDoListViewController: UIViewController, UITabBarDelegate {
    private var viewModel = ToDoViewModel()
    
    lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        
        search.searchBar.searchBarStyle = .prominent
        search.searchBar.delegate = self
        
        return search
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainListCell.self, forCellReuseIdentifier: "MainListCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
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
        
        viewModel.didUpdateData = { [weak self] in
            self?.tableView.reloadData()
        }
        
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
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

extension ToDoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainListCell", for: indexPath) as! MainListCell
        let toDo = viewModel.toDos[indexPath.row]
        cell.configure(with: toDo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDo = viewModel.toDos[indexPath.row]
        let editVC = AddEditToDoViewController()
        editVC.configure(with: toDo)
        navigationController?.pushViewController(editVC, animated: true)
        
    }
    
    
}
