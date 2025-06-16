//
//  CoreDataManager.swift
//  TodoIstApp
//
//  Created by Нурик  Генджалиев   on 15.06.2025.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoistApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
            return persistentContainer.viewContext
        }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createToDo(id: UUID = UUID(), toDoItem: String, isCompleted: Bool, title: String, creationDate: Date = Date()) -> ToDoItem {
        let context = context
        let newToDoItem = ToDoItem(context: context)
        newToDoItem.id = id
        newToDoItem.toDoItem = toDoItem
        newToDoItem.isCompleted = isCompleted
        newToDoItem.title = title
        newToDoItem.creationDate = creationDate
        saveContext()
        return newToDoItem
    }
    
    func fetchAllToDos() -> [ToDoItem] {
        let fetchRequest: NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            fatalError("Failed to fetch ToDos: \(error)")
        }
    }
    
    func updateToDo(toDo: ToDoItem, newToDoItem: String?, isCompleted: Bool, newTitle: String?) {
        if let newToDoItem = newToDoItem {
            toDo.toDoItem = newToDoItem
        }
        if isCompleted != toDo.isCompleted {
            toDo.isCompleted = isCompleted
        }
        if let title = newTitle {
            toDo.title = title
        }
    }
    
    func deleteToDo(toDo: ToDoItem) {
        context.delete(toDo)
        saveContext()
    }
}
