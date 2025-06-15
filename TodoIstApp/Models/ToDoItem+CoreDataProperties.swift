//
//  ToDoItem+CoreDataProperties.swift
//  TodoIstApp
//
//  Created by Нурик  Генджалиев   on 15.06.2025.
//
//

import Foundation
import CoreData


extension ToDoItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoItem> {
        return NSFetchRequest<ToDoItem>(entityName: "ToDoItem")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var toDoItem: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var title: String?
    @NSManaged public var creationDate: Date?

}

extension ToDoItem : Identifiable {

}
