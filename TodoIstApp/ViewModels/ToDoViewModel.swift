//
//  ToDoViewModel.swift
//  TodoIstApp
//
//  Created by Нурик  Генджалиев   on 16.06.2025.
//

import Foundation
import CoreData

class ToDoViewModel {
    private let coreDataManager: CoreDataManager
    
    var didUpdateData: (() -> Void)?
    
    var toDos: [ToDoItem] = [] {
        didSet {
            didUpdateData?()
        }
    }
    
    init(coreDataManager: CoreDataManager = CoreDataManager.shared) {
        self.coreDataManager = coreDataManager
        loadToDos()
    }
    
    func loadToDos() {
        toDos = coreDataManager.fetchAllToDos()
    }
    
    func addToDo(id: UUID = UUID(), toDoItem: String, isCompleted: Bool, title: String, creationDate: Date = Date()) {
        coreDataManager.createToDo(id: id, toDoItem: toDoItem, isCompleted: isCompleted, title: title, creationDate: creationDate)
        loadToDos()
    }
    
    func updateToDo(toDo: ToDoItem, newToDoItem: String, newIsCompleted: Bool, newTitle: String) {
        coreDataManager.updateToDo(toDo: toDo, newToDoItem: newToDoItem, isCompleted: newIsCompleted, newTitle: newTitle)
        loadToDos()
    }
    
    func deleteToDo(at index: Int) {
        let toDo = toDos[index]
        coreDataManager.deleteToDo(toDo: toDo)
        loadToDos()
    }
    
}
