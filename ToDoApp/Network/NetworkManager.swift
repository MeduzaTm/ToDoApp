import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    private let urlSession = URLSession.shared
    
    func fetchTodos(completion: @escaping (Result<[ParseTodo], Error>) -> Void) {
        let request = URLRequest(url: Endpoints.todos.url)
        
        urlSession.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(TodoResponse.self, from: data)
                completion(.success(response.todos))
            } catch {
                completion(.failure(APIError.invalidResponse))
            }
        }.resume()
    }
    
}

enum Endpoints {
    static let baseURL = "https://dummyjson.com"
    
    case todos
    
    var path: String {
        switch self {
        case .todos:
            return "/todos"
        }
    }
    
    var url: URL {
        return URL(string: Endpoints.baseURL + path)!
    }
}

enum APIError: Error {
    case noData
    case invalidResponse
}

struct TodoResponse: Codable {
    let todos: [ParseTodo]
    let total, skip, limit: Int
}

struct ParseTodo: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
