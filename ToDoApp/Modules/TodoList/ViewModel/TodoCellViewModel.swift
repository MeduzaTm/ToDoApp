import Foundation

class TodoCellViewModel {
    private let todo: Todo
    
    var title: String {
        return todo.title ?? "No title"
    }
    
    var description: String? {
        return todo.todoDescription
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: todo.createdAt ?? Date())
    }
    
    var isCompleted: Bool {
        return todo.isCompleted
    }
    
    init(todo: Todo) {
        self.todo = todo
    }
}
