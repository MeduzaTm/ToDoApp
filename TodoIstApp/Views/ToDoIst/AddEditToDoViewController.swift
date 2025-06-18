//
//  AddEditToDoViewController.swift
//  TodoIstApp
//
//  Created by Нурик  Генджалиев   on 15.06.2025.
//

import UIKit

protocol EditDelegate: AnyObject {
    func didUpdateToDo()
}

class AddEditToDoViewController: UIViewController {
    weak var delegate: EditDelegate?
    var editingToDo: ToDoItem?
    private var viewModel = ToDoViewModel()
    let dateFormatter = DateFormatter()
    
    lazy var toDoTitle: UITextField = {
        var title = UITextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 39, weight: .bold)
        title.text = "New ToDo"
        return title
    }()
    
    lazy var dateTitle: UILabel = {
        var title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .secondaryLabel
        title.font = .systemFont(ofSize: 15, weight: .regular)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        title.text = dateFormatter.string(from: Date())
        return title
    }()
    
    lazy var toDoTextView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.text = "Add your toDo"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(toDoTitle)
        view.addSubview(dateTitle)
        view.addSubview(toDoTextView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveToDo))
        
        NSLayoutConstraint.activate([
            toDoTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            toDoTitle.heightAnchor.constraint(equalToConstant: 50),
            toDoTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            dateTitle.topAnchor.constraint(equalTo: toDoTitle.bottomAnchor, constant: 10),
            dateTitle.heightAnchor.constraint(equalToConstant: 30),
            dateTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            toDoTextView.topAnchor.constraint(equalTo: dateTitle.bottomAnchor, constant: 10),
            toDoTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toDoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toDoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toDoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func configure(with toDo: ToDoItem) {
        toDoTitle.text = toDo.title ?? ""
        dateTitle.text = toDo.creationDate?.description ?? ""
        toDoTextView.text = toDo.toDoItem
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateTitle.text = dateFormatter.string(from: toDo.creationDate ?? Date())
    }
    
    @objc private func saveToDo() {
        guard let title = toDoTitle.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !title.isEmpty else {
            showAlert(title: "Error", message: "The title cannot be empty")
            return
        }
        
        let description = toDoTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let existingToDo = editingToDo {
            viewModel.updateToDo(
                id: existingToDo.id ?? UUID(),
                newToDoItem: description,
                newTitle: title
            )
        } else {
            viewModel.addToDo(
                toDoItem: description,
                isCompleted: false,
                title: title
            )
        }
        
        delegate?.didUpdateToDo()
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
