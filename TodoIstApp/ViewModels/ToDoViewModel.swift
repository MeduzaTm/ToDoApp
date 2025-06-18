//
//  ToDoViewModel.swift
//  TodoIstApp
//
//  Created by Нурик  Генджалиев   on 16.06.2025.
//

import Foundation
import CoreData

protocol ToDoViewModelDelegate: AnyObject {
    func didUpdateTasksCount(count: Int)
}

class ToDoViewModel {
    private let coreDataManager: CoreDataManager
    weak var delegate: ToDoViewModelDelegate?
    
    var didUpdateData: (() -> Void)?
    
    var toDos: [ToDoItem] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.didUpdateData?()
                self?.delegate?.didUpdateTasksCount(count: self?.toDos.count ?? 0)
            }
        }
    }
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
        loadToDos()
    }
    
    func loadToDos() {
        toDos = coreDataManager.fetchAllToDos()
    }
    
    func addToDo(id: UUID = UUID(), toDoItem: String, isCompleted: Bool, title: String, creationDate: Date = Date()) -> ToDoItem {
        let newToDo = coreDataManager.createToDo(
            id: id,
            toDoItem: toDoItem,
            isCompleted: isCompleted,
            title: title,
            creationDate: creationDate
        )
        delegate?.didUpdateTasksCount(count: toDos.count)
        loadToDos()
        return newToDo
    }
    
    func updateToDo(id: UUID, newToDoItem: String? = nil, newTitle: String? = nil, newIsCompleted: Bool? = nil) {
        coreDataManager.updateToDo(
            id: id,
            newToDoItem: newToDoItem,
            newIsCompleted: newIsCompleted,
            newTitle: newTitle
        )
        loadToDos()
    }
    
    func deleteToDo(at index: Int) {
        guard index < toDos.count else { return }
        let toDo = toDos[index]
        coreDataManager.deleteToDo(toDo: toDo)
        delegate?.didUpdateTasksCount(count: toDos.count)
        loadToDos()
    }
    
    func toggleToDoCompletion(id: UUID) {
        guard let index = toDos.firstIndex(where: { $0.id == id }) else { return }
        let currentStatus = toDos[index].isCompleted
        
        updateToDo(
            id: id,
            newIsCompleted: !currentStatus
        )
    }
}
