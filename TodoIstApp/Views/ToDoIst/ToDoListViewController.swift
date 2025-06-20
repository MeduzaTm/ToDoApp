//
//  ViewController.swift
//  TodoListApp
//
//  Created by Нурик  Генджалиев   on 13.06.2025.
//

import UIKit

class ToDoIstViewController: UIViewController {
    var viewModel = ToDoViewModel()
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(MainListCell.self, forCellReuseIdentifier: "MainListCell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private lazy var searchController: UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.searchBarStyle = .prominent
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        return search
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Todoist"
        navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        setupUI()
        setupBindings()
        
        if let tabBarController = self.tabBarController as? MainTabBarController {
            tabBarController.addDelegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        (tabBarController as? MainTabBarController)?.showCustomTabBar()
        viewModel.loadToDos()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        (tabBarController as? MainTabBarController)?.hideCustomTabBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        
        UIView.animate(withDuration: 0.3) {
            self.tableView.backgroundColor = UIColor.systemGroupedBackground
        }
    }
    
    private func setupBindings() {
        viewModel.didUpdateData = { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ToDoIstViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.searchToDos(searchText: searchText)
        tableView.reloadData()
    }
}

extension ToDoIstViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.isSearching ? viewModel.filterTodos.count : viewModel.toDos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainListCell", for: indexPath) as! MainListCell
        let toDo = viewModel.toDos[indexPath.row]
        cell.configure(with: toDo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let toDo = viewModel.isSearching ? viewModel.filterTodos[indexPath.row] : viewModel.toDos[indexPath.row]
        
        let editVC = AddEditToDoViewController()
        editVC.configure(with: toDo)
        editVC.editingToDo = toDo
        navigationController?.pushViewController(editVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            UIView.animate(withDuration: 2, animations: {
                self.viewModel.deleteToDo(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.tableView.reloadData()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            UIMenu(title: "", children: [
                UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil"), identifier: nil, handler: { _ in
                    let toDo = self.viewModel.toDos[indexPath.row]
                    let editVC = AddEditToDoViewController()
                    editVC.configure(with: toDo)
                    editVC.editingToDo = toDo
                    self.navigationController?.pushViewController(editVC, animated: true)
                }),
                UIAction(title: "Mark as complete", image: UIImage(systemName: "checkmark"), identifier: nil, handler: { _ in
                    let toDo = self.viewModel.toDos[indexPath.row]
                    self.viewModel.toggleToDoCompletion(id: toDo.id!)
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }),
                UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil, handler: { _ in
                    let activityController = UIActivityViewController(activityItems: [self.viewModel.toDos[indexPath.row].description], applicationActivities: nil)
                    self.present(activityController, animated: true, completion: nil)
                }),
                UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in
                    self.tableView(tableView, commit: .delete, forRowAt: indexPath)
                })
            ])
        }
    }
}

extension ToDoIstViewController: MainTabBarControllerDelegate, EditDelegate {
    func didTapAddButton() {
        let addVC = AddEditToDoViewController()
        addVC.delegate = self
        navigationController?.pushViewController(addVC, animated: true)
    }
    
    func didUpdateToDo() {
        viewModel.loadToDos()
        tableView.reloadData()
    }
}
