//
//  AddEditToDoViewController.swift
//  TodoIstApp
//
//  Created by Нурик  Генджалиев   on 15.06.2025.
//

import UIKit

class AddEditToDoViewController: UIViewController {
    lazy var toDoTitle: UITextField = {
        var title = UITextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 39, weight: .bold)
        title.text = "Заголовоooooooooк"
        return title
    }()
    
    lazy var dateTitle: UILabel = {
        var title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = .secondaryLabel
        title.font = .systemFont(ofSize: 15, weight: .regular)
        title.text = "11/11/2025"
        return title
    }()
    
    lazy var toDoTextView: UITextView = {
        var textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        textView.text = "Описание"
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
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateTitle.text = dateFormatter.string(from: toDo.creationDate ?? Date())
    }
}
