import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var todoDescription: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date?

}

extension Todo : Identifiable {

}
