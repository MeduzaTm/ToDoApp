import UIKit

protocol AddEditTodoViewControllerDelegate: AnyObject {
    func didSaveTodo()
}

class AddEditTodoViewController: UIViewController {
    weak var delegate: AddEditTodoViewControllerDelegate?
    
    private let viewModel: AddEditTodoViewModel
    private var isCompleted = false
    let dateFormatter = DateFormatter()
    private var previousNavigationBarTintColor: UIColor?
    
    lazy var toDoTitle: UITextField = {
        var title = UITextField()
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = .systemFont(ofSize: 39, weight: .bold)
        title.placeholder = "New ToDo"
        title.autocorrectionType = .no
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
        textView.autocorrectionType = .no
        textView.font = .systemFont(ofSize: 17, weight: .regular)
        return textView
    }()
    
    init(todo: Todo? = nil) {
        self.viewModel = AddEditTodoViewModel(todo: todo)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        setupUI()
        setupData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        previousNavigationBarTintColor = navigationController?.navigationBar.tintColor
        navigationController?.navigationBar.tintColor = .systemYellow
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let previous = previousNavigationBarTintColor {
            navigationController?.navigationBar.tintColor = previous
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(toDoTitle)
        view.addSubview(dateTitle)
        view.addSubview(toDoTextView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTodo))
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        NSLayoutConstraint.activate([
            toDoTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            toDoTitle.heightAnchor.constraint(equalToConstant: 50),
            toDoTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toDoTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dateTitle.topAnchor.constraint(equalTo: toDoTitle.bottomAnchor, constant: 10),
            dateTitle.heightAnchor.constraint(equalToConstant: 30),
            dateTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dateTitle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            toDoTextView.topAnchor.constraint(equalTo: dateTitle.bottomAnchor, constant: 10),
            toDoTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toDoTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            toDoTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            toDoTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    
    private func setupData() {
        toDoTitle.text = viewModel.title == "New Task" ? nil : viewModel.title
        toDoTextView.text = viewModel.todoDescription == "Add a description..." ? nil : viewModel.todoDescription
        isCompleted = viewModel.isCompleted
    }
    
    @objc private func toggleChanged(_ sender: UISwitch) {
        isCompleted = sender.isOn
    }
    
    @objc private func saveTodo() {
        guard let title = toDoTitle.text, !title.isEmpty else {
            showAlert(title: "Error", message: "Title cannot be empty")
            return
        }
        
        let description = (toDoTextView.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedDescription = description.isEmpty ? nil : description
        
        viewModel.saveTodo(
            title: title,
            description: normalizedDescription,
            isCompleted: isCompleted
        ) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.delegate?.didSaveTodo()
                    self?.navigationController?.popViewController(animated: true)
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func cancel() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
