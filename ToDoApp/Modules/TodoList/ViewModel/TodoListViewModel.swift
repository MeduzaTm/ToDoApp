import Foundation
import CoreData

class TodoListViewModel {
    private let todoService = TodoService()
    private var todos: [Todo] = []
    
    var todoCount: Int {
        return todos.count
    }
    
    func getTodoAtIndex(_ index: Int) -> TodoCellViewModel {
        let todo = todos[index]
        return TodoCellViewModel(todo: todo)
    }
    
    func fetchInitialTodos(completion: @escaping (Result<Void, Error>) -> Void) {
        todoService.fetchInitialTodos { [weak self] result in
            switch result {
            case .success(let todos):
                self?.todos = todos
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchTodos(completion: @escaping (Result<Void, Error>) -> Void) {
        todoService.fetchTodos { [weak self] result in
            switch result {
            case .success(let todos):
                self?.todos = todos
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteTodo(at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let todo = todos[index]
        todoService.deleteTodo(todo) { [weak self] result in
            switch result {
            case .success(()):
                self?.todos.remove(at: index)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func searchTodos(query: String, completion: @escaping (Result<Void, Error>) -> Void) {
        todoService.searchTodos(with: query) { [weak self] result in
            switch result {
            case .success(let todos):
                self?.todos = todos
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTodoForEditing(at index: Int) -> Todo {
        return todos[index]
    }

    func toggleCompleted(at index: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        let todo = todos[index]
        let newValue = !todo.isCompleted
        todoService.updateTodo(todo, title: todo.title ?? "", description: todo.todoDescription, isCompleted: newValue) { [weak self] result in
            switch result {
            case .success:
                self?.todos[index].isCompleted = newValue
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
