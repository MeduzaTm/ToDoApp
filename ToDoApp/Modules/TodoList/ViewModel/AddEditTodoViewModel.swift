import Foundation
import CoreData

class AddEditTodoViewModel {
    private let todoService = TodoService()
    private var todo: Todo?
    
    init(todo: Todo? = nil) {
        self.todo = todo
    }
    
    var isEditing: Bool {
        return todo != nil
    }
    
    var title: String {
        return todo?.title ?? "New Task"
    }
    
    var todoDescription: String? {
        return todo?.todoDescription ?? "Add a description..."
    }
    
    var isCompleted: Bool {
        return todo?.isCompleted ?? false
    }
    
    func saveTodo(title: String, description: String?, isCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        if let todo = todo {
            todoService.updateTodo(todo, title: title, description: description, isCompleted: isCompleted, completion: completion)
        } else {
            todoService.createTodo(title: title, description: description) { result in
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
