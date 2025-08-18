import CoreData

class TodoService {
    private let coreDataStack = CoreDataStack.shared
    private let networkManager = NetworkManager.shared
    
    func fetchInitialTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        fetchTodos { [weak self] existingResult in
            switch existingResult {
            case .success(let existing) where !existing.isEmpty:
                completion(.success(existing))
            default:
                self?.networkManager.fetchTodos { [weak self] result in
                    switch result {
                    case .success(let todos):
                        self?.saveTodosToCoreData(parseTodos: todos, completion: completion)
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func saveTodosToCoreData(parseTodos: [ParseTodo], completion: @escaping (Result<[Todo], Error>) -> Void) {
        coreDataStack.context.perform {
            var todos = [Todo]()
            
            for parseTodo in parseTodos {
                let todo = Todo(context: self.coreDataStack.context)
                todo.id = intToUUID(parseTodo.id)
                todo.title = parseTodo.todo
                todo.todoDescription = parseTodo.todo
                todo.isCompleted = parseTodo.completed
                todo.createdAt = Date()
                todos.append(todo)
            }
            
            do {
                try self.coreDataStack.context.save()
                completion(.success(todos))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchTodos(completion: @escaping (Result<[Todo], Error>) -> Void) {
        coreDataStack.context.perform {
            let request: NSFetchRequest<Todo> = Todo.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                let todos = try self.coreDataStack.context.fetch(request)
                completion(.success(todos))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func createTodo(title: String, description: String?, completion: @escaping (Result<Todo, Error>) -> Void) {
        coreDataStack.context.perform {
            let todo = Todo(context: self.coreDataStack.context)
            todo.id = UUID()
            todo.title = title
            todo.todoDescription = description
            todo.isCompleted = false
            todo.createdAt = Date()
            
            do {
                try self.coreDataStack.context.save()
                completion(.success(todo))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func updateTodo(_ todo: Todo, title: String, description: String?, isCompleted: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataStack.context.perform {
            todo.title = title
            todo.todoDescription = description
            todo.isCompleted = isCompleted
            
            do {
                try self.coreDataStack.context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func deleteTodo(_ todo: Todo, completion: @escaping (Result<Void, Error>) -> Void) {
        coreDataStack.context.perform {
            self.coreDataStack.context.delete(todo)
            do {
                try self.coreDataStack.context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func searchTodos(with query: String, completion: @escaping (Result<[Todo], Error>) -> Void) {
        coreDataStack.context.perform {
            let request: NSFetchRequest<Todo> = Todo.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", query)
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                let todos = try self.coreDataStack.context.fetch(request)
                completion(.success(todos))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
}
