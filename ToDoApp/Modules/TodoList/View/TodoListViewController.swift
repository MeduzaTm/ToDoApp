import UIKit
import CoreData

class TodoListViewController: UIViewController {
    private var viewModel = TodoListViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private let bottomBar = UIView()
    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .systemYellow
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular)
        button.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TodoCell.self, forCellReuseIdentifier: TodoCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    override func viewDidLoad() {
        setupUI()
        setupSearchController()
        setupLoadData() 
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Todo List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(tableView)
        view.addSubview(bottomBar)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomBar.topAnchor)
        ])
        bottomBar.translatesAutoresizingMaskIntoConstraints = false
        bottomBar.backgroundColor = .systemBackground
        bottomBar.addSubview(countLabel)
        bottomBar.addSubview(addButton)
        addButton.addTarget(self, action: #selector(addTodo), for: .touchUpInside)

        NSLayoutConstraint.activate([
            bottomBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            bottomBar.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            addButton.trailingAnchor.constraint(equalTo: bottomBar.trailingAnchor, constant: -16),
            addButton.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            addButton.widthAnchor.constraint(equalToConstant: 32),
            addButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        NSLayoutConstraint.activate([
            countLabel.centerXAnchor.constraint(equalTo: bottomBar.centerXAnchor),
            countLabel.centerYAnchor.constraint(equalTo: bottomBar.centerYAnchor),
            countLabel.leadingAnchor.constraint(greaterThanOrEqualTo: bottomBar.leadingAnchor, constant: 16),
            countLabel.trailingAnchor.constraint(lessThanOrEqualTo: addButton.leadingAnchor, constant: -16)
        ])

        updateBottomBarCount(animated: false)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Tasks"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupLoadData() {
        if viewModel.todoCount == 0 {
            loadInitialData()
        } else {
            loadData()
        }
    }
    
    private func loadInitialData() {
        viewModel.fetchInitialTodos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.reloadTableAnimated()
                    self?.updateBottomBarCount()
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func loadData() {
        viewModel.fetchTodos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.reloadTableAnimated()
                    self?.updateBottomBarCount()
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func addTodo() {
        let addEditVC = AddEditTodoViewController()
        addEditVC.delegate = self
        navigationController?.pushViewController(addEditVC, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func shareTodo(at indexPath: IndexPath) {
        let todo = viewModel.getTodoForEditing(at: indexPath.row)
        let title = (todo.title ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let description = (todo.todoDescription ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let textItems: [Any] = [title, description].filter { !$0.isEmpty }
        guard !textItems.isEmpty else { return }
        let vc = UIActivityViewController(activityItems: textItems, applicationActivities: nil)
        if let popover = vc.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = self.view.bounds
        }
        present(vc, animated: true)
    }
}

extension TodoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoCell.identifier, for: indexPath) as? TodoCell else {
            return UITableViewCell()
        }
        
        let cellViewModel = viewModel.getTodoAtIndex(indexPath.row)
        cell.configure(with: cellViewModel)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let todo = viewModel.getTodoForEditing(at: indexPath.row)
        let addEditVC = AddEditTodoViewController(todo: todo)
        addEditVC.delegate = self
        navigationController?.pushViewController(addEditVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.deleteTodo(at: indexPath, completion: completion)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return nil }
            return self.makeContextMenu(for: indexPath)
        }
        return configuration
    }
    
    private func makeContextMenu(for indexPath: IndexPath) -> UIMenu {
        let edit = UIAction(title: "Edit", image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
            guard let self = self else { return }
            let todo = self.viewModel.getTodoForEditing(at: indexPath.row)
            let vc = AddEditTodoViewController(todo: todo)
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        let share = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up")) { [weak self] _ in
            self?.shareTodo(at: indexPath)
        }
        let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
            self?.deleteTodo(at: indexPath) { _ in }
        }
        return UIMenu(title: "", children: [edit, share, delete])
    }
    
    private func deleteTodo(at indexPath: IndexPath, completion: @escaping (Bool) -> Void) {
        viewModel.deleteTodo(at: indexPath.row) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.tableView.deleteRows(at: [indexPath], with: .automatic)
                    self?.updateBottomBarCount()
                    completion(true)
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                    completion(false)
                }
            }
        }
    }

    private func updateBottomBarCount(animated: Bool = true) {
        let count = viewModel.todoCount
        let newText = "\(count) \(count == 1 ? "task" : "tasks")"
        guard animated else {
            countLabel.text = newText
            return
        }
        if countLabel.text != newText {
            UIView.transition(with: countLabel, duration: 0.22, options: .transitionCrossDissolve, animations: {
                self.countLabel.text = newText
            })
            UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseOut], animations: {
                self.countLabel.transform = CGAffineTransform(scaleX: 1.06, y: 1.06)
            }, completion: { _ in
                UIView.animate(withDuration: 0.18, delay: 0, options: [.curveEaseIn], animations: {
                    self.countLabel.transform = .identity
                }, completion: nil)
            })
        }
    }

    private func reloadTableAnimated() {
        UIView.transition(with: tableView, duration: 0.25, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        }, completion: nil)
    }
}

extension TodoListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        viewModel.searchTodos(query: query) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.reloadTableAnimated()
                    self?.updateBottomBarCount()
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
}

extension TodoListViewController: AddEditTodoViewControllerDelegate {
    func didSaveTodo() {
        viewModel.fetchTodos { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.reloadTableAnimated()
                    self?.updateBottomBarCount()
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
}

extension TodoListViewController: TodoCellDelegate {
    func todoCellDidLongPressCircle(_ cell: TodoCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        viewModel.toggleCompleted(at: indexPath.row) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.tableView.reloadRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    self?.showErrorAlert(message: error.localizedDescription)
                }
            }
        }
    }
}
